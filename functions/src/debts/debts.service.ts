import {AuditService} from "../audit/audit.service.js";
import {appLogger} from "../shared/utils/logger.js";
import {ContactsRepository} from "../contacts/contacts.repository.js";
import type {ContactRecord} from "../contacts/contacts.types.js";
import {NotificationsService} from "../notifications/notifications.service.js";
import {
  DebtAlreadySettledError,
  DebtContactNotFoundError,
  DebtNotFoundError,
  DebtUnauthorizedAccessError,
  DebtUnauthorizedContactError,
  InvalidDebtAmountError,
  InvalidDebtDirectionError,
  InvalidSettlementAmountError,
  SettlementExceedsRemainingBalanceError,
} from "./debts.errors.js";
import {DebtsRepository} from "./debts.repository.js";
import type {
  DebtDirection,
  DebtRecord,
  DebtSettlementRecord,
} from "./debts.types.js";

/**
 * Service for debt workflows.
 */
export class DebtsService {
  /**
   * Creates a debts service instance.
   * @param {DebtsRepository} debtsRepository Debt repository dependency.
   * @param {ContactsRepository} contactsRepository
   * Contact repository dependency.
   */
  constructor(
    private readonly debtsRepository: DebtsRepository = new DebtsRepository(),
    private readonly contactsRepository: ContactsRepository =
    new ContactsRepository(),
    private readonly auditService: AuditService = new AuditService(),
    private readonly notificationsService: NotificationsService =
    new NotificationsService(),
  ) {}

  /**
   * Creates a debt record for the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the debt owner.
   * @param {string} contactId Related contact ID.
   * @param {string} direction Debt direction.
   * @param {string} currency Currency code.
   * @param {number} amount Original debt amount.
   * @param {string | null} description Optional debt description.
   * @return {Promise<DebtRecord>} Created debt record.
   */
  async createDebt(
    ownerUid: string,
    contactId: string,
    direction: string,
    currency: string,
    amount: number,
    description: string | null,
  ): Promise<DebtRecord> {
    if (amount <= 0) {
      throw new InvalidDebtAmountError();
    }

    const validatedDirection = this.validateDirection(direction);
    await this.assertContactOwnership(ownerUid, contactId);

    const debt = await this.debtsRepository.createDebt(
      ownerUid,
      contactId,
      validatedDirection,
      currency,
      amount,
      description,
    );

    appLogger.info("Debt created successfully.", {
      event: "debts.create.completed",
      ownerUid,
      contactId,
      debtId: debt.debtId,
    });

    await this.auditService.createAuditLogSafely(
      {
        ownerUid,
        entityType: "debt",
        entityId: debt.debtId,
        action: "debt_created",
        metadata: {
          currency,
          amount,
          direction: validatedDirection,
        },
      },
      {
        sourceEvent: "debts.create.completed",
        debtId: debt.debtId,
        contactId,
      },
    );

    await this.notificationsService.createNotificationSafely(
      {
        ownerUid,
        type: "debt_created",
        title: "Debt created",
        body: "A new debt record was created.",
        metadata: {
          currency,
          amount,
          direction: validatedDirection,
          debtId: debt.debtId,
        },
      },
      {
        sourceEvent: "debts.create.completed",
        debtId: debt.debtId,
      },
    );

    return debt;
  }

  /**
   * Returns debts owned by the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the debt owner.
   * @return {Promise<DebtRecord[]>} Debt records.
   */
  async getDebts(ownerUid: string): Promise<DebtRecord[]> {
    return this.debtsRepository.getDebtsByOwner(ownerUid);
  }

  /**
   * Records a debt settlement and updates remaining amount atomically.
   * @param {string} ownerUid Firebase Auth UID of the debt owner.
   * @param {string} debtId Debt document ID.
   * @param {number} amount Settlement amount.
   * @return {Promise<DebtSettlementRecord>} Created settlement record.
   */
  async recordDebtSettlement(
    ownerUid: string,
    debtId: string,
    amount: number,
  ): Promise<DebtSettlementRecord> {
    if (amount <= 0) {
      throw new InvalidSettlementAmountError();
    }

    const settlement = await this.debtsRepository.runTransaction(
      async (transaction) => {
        const debt = await this.debtsRepository.getDebtByIdInTransaction(
          transaction,
          debtId,
        );

        this.assertDebtOwnership(ownerUid, debtId, debt);
        this.assertDebtIsActive(ownerUid, debt);

        if (amount > debt.remainingAmount) {
          appLogger.warn("Settlement exceeds remaining debt balance.", {
            event: "debts.settlement.exceeds_remaining",
            ownerUid,
            debtId,
            amount,
            remainingAmount: debt.remainingAmount,
          });
          throw new SettlementExceedsRemainingBalanceError();
        }

        const nextRemainingAmount = debt.remainingAmount - amount;
        const nextStatus = nextRemainingAmount === 0 ? "settled" : debt.status;
        const createdSettlement =
          this.debtsRepository.createSettlementInTransaction(
            transaction,
            ownerUid,
            debtId,
            amount,
            debt.currency,
          );

        this.debtsRepository.updateDebtRemainingAmountInTransaction(
          transaction,
          debtId,
          nextRemainingAmount,
          nextStatus,
        );

        return createdSettlement;
      },
    );

    appLogger.info("Debt settlement recorded successfully.", {
      event: "debts.settlement.recorded",
      ownerUid,
      debtId,
      settlementId: settlement.settlementId,
      amount,
    });

    await this.auditService.createAuditLogSafely(
      {
        ownerUid,
        entityType: "debt",
        entityId: debtId,
        action: "debt_settlement_created",
        metadata: {
          currency: settlement.currency,
          amount: settlement.amount,
        },
      },
      {
        sourceEvent: "debts.settlement.recorded",
        debtId,
        settlementId: settlement.settlementId,
      },
    );

    await this.notificationsService.createNotificationSafely(
      {
        ownerUid,
        type: "debt_settlement_recorded",
        title: "Debt settlement recorded",
        body: "A debt settlement was recorded successfully.",
        metadata: {
          currency: settlement.currency,
          amount: settlement.amount,
          debtId,
          settlementId: settlement.settlementId,
        },
      },
      {
        sourceEvent: "debts.settlement.recorded",
        debtId,
        settlementId: settlement.settlementId,
      },
    );

    return settlement;
  }

  /**
   * Returns settlement history for a debt owned by the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the debt owner.
   * @param {string} debtId Debt document ID.
   * @return {Promise<DebtSettlementRecord[]>} Settlement history.
   */
  async getDebtSettlements(
    ownerUid: string,
    debtId: string,
  ): Promise<DebtSettlementRecord[]> {
    const debt = await this.debtsRepository.getDebtById(debtId);

    this.assertDebtOwnership(ownerUid, debtId, debt);

    return this.debtsRepository.getSettlementsByDebt(debtId);
  }

  /**
   * Validates a debt direction value.
   * @param {string} direction Candidate direction value.
   * @return {DebtDirection} Validated debt direction.
   */
  private validateDirection(direction: string): DebtDirection {
    if (
      direction !== "owed_by_contact" &&
      direction !== "owed_to_contact"
    ) {
      throw new InvalidDebtDirectionError();
    }

    return direction;
  }

  /**
   * Ensures that a contact exists and belongs to the authenticated owner.
   * @param {string} ownerUid Firebase Auth UID of the debt owner.
   * @param {string} contactId Contact document ID.
   * @return {Promise<ContactRecord>} Owned contact record.
   */
  private async assertContactOwnership(
    ownerUid: string,
    contactId: string,
  ): Promise<ContactRecord> {
    const contact = await this.contactsRepository.getContactById(contactId);

    if (!contact) {
      appLogger.warn("Contact not found for debt creation.", {
        event: "debts.create.contact_not_found",
        ownerUid,
        contactId,
      });
      throw new DebtContactNotFoundError();
    }

    if (contact.ownerUid !== ownerUid) {
      appLogger.warn("Unauthorized contact access denied for debt creation.", {
        event: "debts.create.contact_unauthorized",
        ownerUid,
        contactId,
        contactOwnerUid: contact.ownerUid,
      });
      throw new DebtUnauthorizedContactError();
    }

    return contact;
  }

  /**
   * Ensures that a debt exists and belongs to the authenticated owner.
   * @param {string} ownerUid Firebase Auth UID of the debt owner.
   * @param {string} debtId Debt document ID.
   * @param {DebtRecord | null} debt Debt record to validate.
   */
  private assertDebtOwnership(
    ownerUid: string,
    debtId: string,
    debt: DebtRecord | null,
  ): asserts debt is DebtRecord {
    if (!debt) {
      appLogger.warn("Debt not found.", {
        event: "debts.lookup.not_found",
        ownerUid,
        debtId,
      });
      throw new DebtNotFoundError();
    }

    if (debt.ownerUid !== ownerUid) {
      appLogger.warn("Unauthorized debt access denied.", {
        event: "debts.lookup.unauthorized",
        ownerUid,
        debtId,
        debtOwnerUid: debt.ownerUid,
      });
      throw new DebtUnauthorizedAccessError();
    }
  }

  /**
   * Ensures that a debt is active before applying a settlement.
   * @param {string} ownerUid Firebase Auth UID of the debt owner.
   * @param {DebtRecord} debt Debt record to validate.
   * @return {void}
   */
  private assertDebtIsActive(ownerUid: string, debt: DebtRecord): void {
    if (debt.status !== "active") {
      appLogger.warn("Settlement attempted for non-active debt.", {
        event: "debts.settlement.non_active_debt",
        ownerUid,
        debtId: debt.debtId,
        status: debt.status,
      });
      throw new DebtAlreadySettledError();
    }
  }
}
