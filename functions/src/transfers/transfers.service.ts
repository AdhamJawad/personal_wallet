import {Transaction} from "firebase-admin/firestore";

import {AuditService} from "../audit/audit.service.js";
import {NotificationsService} from "../notifications/notifications.service.js";
import {appLogger} from "../shared/utils/logger.js";
import {WalletsRepository} from "../wallets/wallets.repository.js";
import type {CreateLedgerEntryInput} from "../wallets/ledger.types.js";
import type {WalletRecord} from "../wallets/wallets.types.js";
import {
  InvalidTransferAmountError,
  SelfTransferError,
  TransferInsufficientFundsError,
  TransferUnauthorizedWalletAccessError,
  TransferWalletNotFoundError,
  UnsupportedTransferCurrencyError,
} from "./transfers.errors.js";
import {TransfersRepository} from "./transfers.repository.js";
import type {
  CreateUserTransferInput,
  CreateUserTransferResponse,
  TransferRecord,
} from "./transfers.types.js";

/**
 * Service for transfer workflows.
 */
export class TransfersService {
  /**
   * Creates a transfers service instance.
   * @param {TransfersRepository} transfersRepository
   * Transfer repository dependency.
   * @param {WalletsRepository} walletsRepository Wallet repository dependency.
   */
  constructor(
    private readonly transfersRepository: TransfersRepository =
    new TransfersRepository(),
    private readonly walletsRepository: WalletsRepository =
    new WalletsRepository(),
    private readonly auditService: AuditService = new AuditService(),
    private readonly notificationsService: NotificationsService =
    new NotificationsService(),
  ) {}

  /**
   * Creates a user-to-user transfer across different wallet owners.
   * @param {CreateUserTransferInput} transfer Transfer payload.
   * @return {Promise<CreateUserTransferResponse>} Transfer creation response.
   */
  async createUserTransfer(
    transfer: CreateUserTransferInput,
  ): Promise<CreateUserTransferResponse> {
    if (transfer.amount <= 0) {
      throw new InvalidTransferAmountError();
    }

    const createdTransfer = await this.transfersRepository.runTransaction(
      async (transaction) => {
        const sourceWallet = await this.requireSourceWalletInTransaction(
          transaction,
          transfer.senderUid,
          transfer.sourceWalletId,
        );
        const destinationWallet =
          await this.requireDestinationWalletInTransaction(
            transaction,
            transfer.senderUid,
            transfer.destinationWalletId,
          );

        if (destinationWallet.ownerUid === transfer.senderUid) {
          appLogger.warn("Self user transfer blocked.", {
            event: "transfers.create.self_transfer",
            senderUid: transfer.senderUid,
            sourceWalletId: transfer.sourceWalletId,
            destinationWalletId: transfer.destinationWalletId,
          });
          throw new SelfTransferError();
        }

        this.assertCurrencySupported(
          transfer.senderUid,
          sourceWallet,
          destinationWallet,
          transfer.currency,
        );

        const availableBalance = await this.walletsRepository
          .getWalletBalanceForCurrencyInTransaction(
            transaction,
            transfer.sourceWalletId,
            transfer.currency,
          );

        if (availableBalance < transfer.amount) {
          appLogger.warn("Insufficient funds for user transfer.", {
            event: "transfers.create.insufficient_funds",
            senderUid: transfer.senderUid,
            sourceWalletId: transfer.sourceWalletId,
            currency: transfer.currency,
            availableBalance,
            requestedAmount: transfer.amount,
          });
          throw new TransferInsufficientFundsError();
        }

        const created = this.transfersRepository.createTransferInTransaction(
          transaction,
          {
            senderUid: transfer.senderUid,
            receiverUid: destinationWallet.ownerUid,
            sourceWalletId: transfer.sourceWalletId,
            destinationWalletId: transfer.destinationWalletId,
            currency: transfer.currency,
            amount: transfer.amount,
          },
        );

        this.createTransferLedgerEntries(
          transaction,
          transfer,
          destinationWallet.ownerUid,
          created.transferId,
        );

        return created;
      },
    );

    appLogger.info("User transfer created successfully.", {
      event: "transfers.create.completed",
      transferId: createdTransfer.transferId,
      senderUid: transfer.senderUid,
      receiverUid: createdTransfer.receiverUid,
      sourceWalletId: transfer.sourceWalletId,
      destinationWalletId: transfer.destinationWalletId,
      currency: transfer.currency,
      amount: transfer.amount,
    });

    await Promise.all([
      this.auditService.createAuditLogSafely(
        {
          ownerUid: transfer.senderUid,
          entityType: "transfer",
          entityId: createdTransfer.transferId,
          action: "user_transfer_created",
          metadata: {
            currency: transfer.currency,
            amount: transfer.amount,
          },
        },
        {
          sourceEvent: "transfers.create.completed",
          transferId: createdTransfer.transferId,
          role: "sender",
        },
      ),
      this.auditService.createAuditLogSafely(
        {
          ownerUid: createdTransfer.receiverUid,
          entityType: "transfer",
          entityId: createdTransfer.transferId,
          action: "user_transfer_created",
          metadata: {
            currency: transfer.currency,
            amount: transfer.amount,
          },
        },
        {
          sourceEvent: "transfers.create.completed",
          transferId: createdTransfer.transferId,
          role: "receiver",
        },
      ),
      this.notificationsService.createNotificationSafely(
        {
          ownerUid: createdTransfer.receiverUid,
          type: "transfer_received",
          title: "Transfer received",
          body: "You received a wallet transfer.",
          metadata: {
            currency: transfer.currency,
            amount: transfer.amount,
            transferId: createdTransfer.transferId,
          },
        },
        {
          sourceEvent: "transfers.create.completed",
          transferId: createdTransfer.transferId,
          receiverUid: createdTransfer.receiverUid,
        },
      ),
    ]);

    return {
      success: true,
      transferId: createdTransfer.transferId,
    };
  }

  /**
   * Returns transfers where the user is the sender or receiver.
   * @param {string} participantUid Firebase Auth UID of the participant.
   * @return {Promise<TransferRecord[]>} Transfer records.
   */
  async getTransfers(participantUid: string): Promise<TransferRecord[]> {
    return this.transfersRepository.getTransfersByParticipant(participantUid);
  }

  /**
   * Ensures the source wallet exists and belongs to the sender.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} senderUid Firebase Auth UID of the sender.
   * @param {string} walletId Source wallet document ID.
   * @return {Promise<WalletRecord>} Owned source wallet record.
   */
  private async requireSourceWalletInTransaction(
    transaction: Transaction,
    senderUid: string,
    walletId: string,
  ): Promise<WalletRecord> {
    const wallet = await this.walletsRepository.getWalletByIdInTransaction(
      transaction,
      walletId,
    );

    if (!wallet) {
      appLogger.warn("Source wallet not found for user transfer.", {
        event: "transfers.create.source_wallet_not_found",
        senderUid,
        walletId,
      });
      throw new TransferWalletNotFoundError();
    }

    if (wallet.ownerUid !== senderUid) {
      appLogger.warn("Unauthorized source wallet access denied.", {
        event: "transfers.create.source_wallet_unauthorized",
        senderUid,
        walletId,
        walletOwnerUid: wallet.ownerUid,
      });
      throw new TransferUnauthorizedWalletAccessError();
    }

    return wallet;
  }

  /**
   * Ensures the destination wallet exists.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {string} senderUid Firebase Auth UID of the sender.
   * @param {string} walletId Destination wallet document ID.
   * @return {Promise<WalletRecord>} Destination wallet record.
   */
  private async requireDestinationWalletInTransaction(
    transaction: Transaction,
    senderUid: string,
    walletId: string,
  ): Promise<WalletRecord> {
    const wallet = await this.walletsRepository.getWalletByIdInTransaction(
      transaction,
      walletId,
    );

    if (!wallet) {
      appLogger.warn("Destination wallet not found for user transfer.", {
        event: "transfers.create.destination_wallet_not_found",
        senderUid,
        walletId,
      });
      throw new TransferWalletNotFoundError();
    }

    return wallet;
  }

  /**
   * Ensures both wallets support the requested currency.
   * @param {string} senderUid Firebase Auth UID of the sender.
   * @param {WalletRecord} sourceWallet Source wallet record.
   * @param {WalletRecord} destinationWallet Destination wallet record.
   * @param {string} currency Requested currency.
   * @return {void}
   */
  private assertCurrencySupported(
    senderUid: string,
    sourceWallet: WalletRecord,
    destinationWallet: WalletRecord,
    currency: string,
  ): void {
    if (
      !sourceWallet.supportedCurrencies.includes(currency) ||
      !destinationWallet.supportedCurrencies.includes(currency)
    ) {
      appLogger.warn("Unsupported currency for user transfer.", {
        event: "transfers.create.invalid_currency",
        senderUid,
        sourceWalletId: sourceWallet.walletId,
        destinationWalletId: destinationWallet.walletId,
        currency,
      });
      throw new UnsupportedTransferCurrencyError();
    }
  }

  /**
   * Creates transfer ledger entries with a shared reference ID.
   * @param {Transaction} transaction Active Firestore transaction.
   * @param {CreateUserTransferInput} transfer Transfer payload.
   * @param {string} receiverUid Firebase Auth UID of the receiver.
   * @param {string} transferId Shared transfer reference ID.
   * @return {void}
   */
  private createTransferLedgerEntries(
    transaction: Transaction,
    transfer: CreateUserTransferInput,
    receiverUid: string,
    transferId: string,
  ): void {
    const outEntry: CreateLedgerEntryInput = {
      walletId: transfer.sourceWalletId,
      ownerUid: transfer.senderUid,
      entryType: "transfer_out",
      currency: transfer.currency,
      amount: transfer.amount,
      referenceId: transferId,
      metadata: {
        transferId,
        sourceWalletId: transfer.sourceWalletId,
        destinationWalletId: transfer.destinationWalletId,
        senderUid: transfer.senderUid,
        receiverUid,
      },
    };

    const inEntry: CreateLedgerEntryInput = {
      walletId: transfer.destinationWalletId,
      ownerUid: receiverUid,
      entryType: "transfer_in",
      currency: transfer.currency,
      amount: transfer.amount,
      referenceId: transferId,
      metadata: {
        transferId,
        sourceWalletId: transfer.sourceWalletId,
        destinationWalletId: transfer.destinationWalletId,
        senderUid: transfer.senderUid,
        receiverUid,
      },
    };

    this.walletsRepository.createLedgerEntryInTransaction(
      transaction,
      outEntry,
    );
    this.walletsRepository.createLedgerEntryInTransaction(
      transaction,
      inEntry,
    );
  }
}
