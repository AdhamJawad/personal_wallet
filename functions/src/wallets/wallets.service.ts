import {appLogger} from "../shared/utils/logger.js";
import type {LedgerEntryRecord} from "./ledger.types.js";
import {
  WalletCreationError,
  WalletNotFoundError,
  WalletUnauthorizedError,
} from "./wallets.errors.js";
import {WalletsRepository} from "./wallets.repository.js";
import type {
  WalletBalancesResponse,
  WalletRecord,
} from "./wallets.types.js";

/**
 * Service for wallet workflows.
 */
export class WalletsService {
  /**
   * Creates a wallets service instance.
   * @param {WalletsRepository} walletsRepository Wallet repository dependency.
   */
  constructor(
    private readonly walletsRepository: WalletsRepository =
    new WalletsRepository(),
  ) {}

  /**
   * Creates a wallet for the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @param {string} name Wallet display name.
   * @return {Promise<WalletRecord>} Created wallet record.
   */
  async createWallet(ownerUid: string, name: string): Promise<WalletRecord> {
    try {
      const wallet = await this.walletsRepository.createWallet(ownerUid, name);

      appLogger.info("Wallet created successfully.", {
        event: "wallets.create.completed",
        ownerUid,
        walletId: wallet.walletId,
      });

      return wallet;
    } catch (error) {
      appLogger.error("Wallet creation failed.", {
        event: "wallets.create.failed",
        ownerUid,
        error: error instanceof Error ? error.message : "unknown_error",
      });
      throw new WalletCreationError();
    }
  }

  /**
   * Returns wallets owned by the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @return {Promise<WalletRecord[]>} Wallet records.
   */
  async getWallets(ownerUid: string): Promise<WalletRecord[]> {
    return this.walletsRepository.getWalletsByOwner(ownerUid);
  }

  /**
   * Returns ledger entries for a wallet owned by the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @param {string} walletId Wallet document ID.
   * @return {Promise<LedgerEntryRecord[]>} Wallet ledger entries.
   */
  async getWalletLedger(
    ownerUid: string,
    walletId: string,
  ): Promise<LedgerEntryRecord[]> {
    await this.assertWalletOwnership(ownerUid, walletId, "wallets.ledger");

    return this.walletsRepository.getWalletLedger(walletId);
  }

  /**
   * Returns derived balances for a wallet owned by the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @param {string} walletId Wallet document ID.
   * @return {Promise<WalletBalancesResponse>} Derived wallet balances.
   */
  async getWalletBalances(
    ownerUid: string,
    walletId: string,
  ): Promise<WalletBalancesResponse> {
    await this.assertWalletOwnership(ownerUid, walletId, "wallets.balances");
    const balances = await this.walletsRepository.getWalletBalances(walletId);

    appLogger.info("Wallet balances calculated successfully.", {
      event: "wallets.balances.completed",
      ownerUid,
      walletId,
      currencies: Object.keys(balances),
    });

    return {
      walletId,
      balances,
    };
  }

  /**
   * Ensures that a wallet exists and belongs to the authenticated owner.
   * @param {string} ownerUid Firebase Auth UID of the wallet owner.
   * @param {string} walletId Wallet document ID.
   * @param {string} eventPrefix Logging event prefix.
   * @return {Promise<void>} Resolves when ownership is confirmed.
   */
  private async assertWalletOwnership(
    ownerUid: string,
    walletId: string,
    eventPrefix: string,
  ): Promise<void> {
    const wallet = await this.walletsRepository.getWalletById(walletId);

    if (!wallet) {
      appLogger.warn("Wallet not found for owned access check.", {
        event: `${eventPrefix}.wallet_not_found`,
        ownerUid,
        walletId,
      });
      throw new WalletNotFoundError();
    }

    if (wallet.ownerUid !== ownerUid) {
      appLogger.warn("Unauthorized wallet access denied.", {
        event: `${eventPrefix}.unauthorized`,
        ownerUid,
        walletId,
        walletOwnerUid: wallet.ownerUid,
      });
      throw new WalletUnauthorizedError();
    }
  }
}
