import {CallableRequest, HttpsError, onCall} from "firebase-functions/https";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {AppError} from "../shared/errors/app.error.js";
import {ValidationError} from "../shared/errors/validation.error.js";
import {appLogger} from "../shared/utils/logger.js";
import {
  DebtAlreadySettledError,
  DebtContactNotFoundError,
  DebtNotFoundError,
  DebtUnauthenticatedError,
  DebtUnauthorizedAccessError,
  DebtUnauthorizedContactError,
  InvalidDebtAmountError,
  InvalidDebtDirectionError,
  InvalidSettlementAmountError,
  SettlementExceedsRemainingBalanceError,
} from "./debts.errors.js";
import {DebtsService} from "./debts.service.js";
import type {
  CreateDebtRequest,
  DebtRecord,
  DebtSettlementRecord,
  GetDebtSettlementsRequest,
  RecordDebtSettlementRequest,
} from "./debts.types.js";

/**
 * Controller for the debts module.
 */
export class DebtsController {
  /**
   * Creates a debts controller instance.
   * @param {DebtsService} debtsService Debt service dependency.
   */
  constructor(
    private readonly debtsService: DebtsService = new DebtsService(),
  ) {}

  /**
   * Creates a debt record for the authenticated user.
   * @return {unknown} Callable Firebase function handler.
   */
  createDebt() {
    return onCall<CreateDebtRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<DebtRecord> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const payload = this.validateCreateDebtRequest(request.data);

        appLogger.info("Create debt request received.", {
          event: "debts.create.requested",
          ownerUid,
          contactId: payload.contactId,
          direction: payload.direction,
          currency: payload.currency,
          amount: payload.amount,
        });

        try {
          return await this.debtsService.createDebt(
            ownerUid,
            payload.contactId,
            payload.direction,
            payload.currency,
            payload.amount,
            payload.description,
          );
        } catch (error) {
          appLogger.error("Create debt request failed.", {
            event: "debts.create.error",
            ownerUid,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to create debt.");
        }
      },
    );
  }

  /**
   * Returns debts owned by the authenticated user.
   * @return {unknown} Callable Firebase function handler.
   */
  getDebts() {
    return onCall(
      {region: APP_CONSTANTS.region},
      async (request): Promise<DebtRecord[]> => {
        const ownerUid = this.requireAuthenticatedUid(request);

        appLogger.info("Get debts request received.", {
          event: "debts.list.requested",
          ownerUid,
        });

        try {
          return await this.debtsService.getDebts(ownerUid);
        } catch (error) {
          appLogger.error("Get debts request failed.", {
            event: "debts.list.error",
            ownerUid,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to load debts.");
        }
      },
    );
  }

  /**
   * Records a settlement against a debt owned by the authenticated user.
   * @return {unknown} Callable Firebase function handler.
   */
  recordDebtSettlement() {
    return onCall<RecordDebtSettlementRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<DebtSettlementRecord> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const payload = this.validateRecordDebtSettlementRequest(request.data);

        appLogger.info("Record debt settlement request received.", {
          event: "debts.settlement.requested",
          ownerUid,
          debtId: payload.debtId,
          amount: payload.amount,
        });

        try {
          return await this.debtsService.recordDebtSettlement(
            ownerUid,
            payload.debtId,
            payload.amount,
          );
        } catch (error) {
          appLogger.error("Record debt settlement request failed.", {
            event: "debts.settlement.error",
            ownerUid,
            debtId: payload.debtId,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to record debt settlement.");
        }
      },
    );
  }

  /**
   * Returns settlement history for a debt owned by the authenticated user.
   * @return {unknown} Callable Firebase function handler.
   */
  getDebtSettlements() {
    return onCall<GetDebtSettlementsRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<DebtSettlementRecord[]> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const payload = this.validateGetDebtSettlementsRequest(request.data);

        appLogger.info("Get debt settlements request received.", {
          event: "debts.settlement.list.requested",
          ownerUid,
          debtId: payload.debtId,
        });

        try {
          return await this.debtsService.getDebtSettlements(
            ownerUid,
            payload.debtId,
          );
        } catch (error) {
          appLogger.error("Get debt settlements request failed.", {
            event: "debts.settlement.list.error",
            ownerUid,
            debtId: payload.debtId,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to load debt settlements.");
        }
      },
    );
  }

  /**
   * Extracts the authenticated Firebase UID from the callable request.
   * @param {CallableRequest<unknown>} request Callable request.
   * @return {string} Authenticated Firebase UID.
   */
  private requireAuthenticatedUid(request: CallableRequest<unknown>): string {
    const uid = request.auth?.uid;

    if (!uid) {
      throw new DebtUnauthenticatedError();
    }

    return uid;
  }

  /**
   * Validates the create debt request payload.
   * @param {CreateDebtRequest | undefined} data Callable request payload.
   * @return {object} Normalized debt payload.
   */
  private validateCreateDebtRequest(
    data: CreateDebtRequest | undefined,
  ): {
    contactId: string;
    direction: string;
    currency: string;
    amount: number;
    description: string | null;
  } {
    if (typeof data?.contactId !== "string" || !data.contactId.trim()) {
      throw new ValidationError("A valid contactId is required.", {
        field: "contactId",
      });
    }

    if (typeof data?.direction !== "string" || !data.direction.trim()) {
      throw new ValidationError("A valid direction is required.", {
        field: "direction",
      });
    }

    if (typeof data?.currency !== "string" || !data.currency.trim()) {
      throw new ValidationError("A valid currency is required.", {
        field: "currency",
      });
    }

    if (typeof data?.amount !== "number" || Number.isNaN(data.amount)) {
      throw new ValidationError("A valid amount is required.", {
        field: "amount",
      });
    }

    return {
      contactId: data.contactId.trim(),
      direction: data.direction.trim(),
      currency: data.currency.trim().toUpperCase(),
      amount: data.amount,
      description: typeof data.description === "string" ?
        data.description.trim() || null :
        null,
    };
  }

  /**
   * Validates the record debt settlement request payload.
   * @param {RecordDebtSettlementRequest | undefined} data Request payload.
   * @return {object} Normalized request payload.
   */
  private validateRecordDebtSettlementRequest(
    data: RecordDebtSettlementRequest | undefined,
  ): {debtId: string; amount: number} {
    if (typeof data?.debtId !== "string" || !data.debtId.trim()) {
      throw new ValidationError("A valid debtId is required.", {
        field: "debtId",
      });
    }

    if (typeof data.amount !== "number" || Number.isNaN(data.amount)) {
      throw new ValidationError("A valid amount is required.", {
        field: "amount",
      });
    }

    return {
      debtId: data.debtId.trim(),
      amount: data.amount,
    };
  }

  /**
   * Validates the get debt settlements request payload.
   * @param {GetDebtSettlementsRequest | undefined} data
   * Callable request payload.
   * @return {{debtId: string}} Normalized request payload.
   */
  private validateGetDebtSettlementsRequest(
    data: GetDebtSettlementsRequest | undefined,
  ): {debtId: string} {
    if (typeof data?.debtId !== "string" || !data.debtId.trim()) {
      throw new ValidationError("A valid debtId is required.", {
        field: "debtId",
      });
    }

    return {
      debtId: data.debtId.trim(),
    };
  }

  /**
   * Maps internal application errors to callable HTTPS errors.
   * @param {unknown} error Error raised by the debts layer.
   * @param {string} fallbackMessage Fallback error message.
   * @return {HttpsError} Callable-friendly error response.
   */
  private toHttpsError(error: unknown, fallbackMessage: string): HttpsError {
    if (error instanceof HttpsError) {
      return error;
    }

    if (error instanceof ValidationError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof DebtUnauthenticatedError) {
      return new HttpsError("unauthenticated", error.message, error.details);
    }

    if (error instanceof InvalidDebtAmountError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof InvalidDebtDirectionError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof DebtContactNotFoundError) {
      return new HttpsError("not-found", error.message, error.details);
    }

    if (error instanceof DebtUnauthorizedContactError) {
      return new HttpsError("permission-denied", error.message, error.details);
    }

    if (error instanceof DebtNotFoundError) {
      return new HttpsError("not-found", error.message, error.details);
    }

    if (error instanceof DebtUnauthorizedAccessError) {
      return new HttpsError("permission-denied", error.message, error.details);
    }

    if (error instanceof InvalidSettlementAmountError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof SettlementExceedsRemainingBalanceError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof DebtAlreadySettledError) {
      return new HttpsError(
        "failed-precondition",
        error.message,
        error.details,
      );
    }

    if (error instanceof AppError) {
      return new HttpsError("internal", error.message, error.details);
    }

    return new HttpsError("internal", fallbackMessage);
  }
}
