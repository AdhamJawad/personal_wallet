export type LedgerEntryType =
  | "deposit"
  | "withdrawal"
  | "transfer_in"
  | "transfer_out"
  | "exchange_in"
  | "exchange_out"
  | "debt_settlement_in"
  | "debt_settlement_out";

export interface CreateLedgerEntryInput {
  walletId: string;
  ownerUid: string;
  entryType: LedgerEntryType;
  currency: string;
  amount: number;
  referenceId: string | null;
  metadata: Record<string, unknown>;
}

export interface LedgerEntryRecord {
  entryId: string;
  walletId: string;
  ownerUid: string;
  entryType: LedgerEntryType;
  currency: string;
  amount: number;
  referenceId: string | null;
  metadata: Record<string, unknown>;
  createdAt?: Date;
}

export interface GetWalletLedgerRequest {
  walletId: string;
}
