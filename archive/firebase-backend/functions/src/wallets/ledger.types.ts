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

export interface CreateDepositInput {
  walletId: string;
  ownerUid: string;
  currency: string;
  amount: number;
  reason?: string;
}

export interface CreateDepositRequest {
  walletId: string;
  currency: string;
  amount: number;
  reason?: string;
}

export interface CreateDepositResponse {
  success: true;
  ledgerEntryId: string;
}

export interface CreateInternalTransferInput {
  fromWalletId: string;
  toWalletId: string;
  ownerUid: string;
  currency: string;
  amount: number;
  reason?: string;
}

export interface CreateInternalTransferRequest {
  fromWalletId: string;
  toWalletId: string;
  currency: string;
  amount: number;
  reason?: string;
}

export interface CreateInternalTransferResponse {
  success: true;
  referenceId: string;
}

export interface CreateExchangeInput {
  walletId: string;
  ownerUid: string;
  fromCurrency: string;
  toCurrency: string;
  fromAmount: number;
  exchangeRate: number;
}

export interface CreateExchangeRequest {
  walletId: string;
  fromCurrency: string;
  toCurrency: string;
  fromAmount: number;
  exchangeRate: number;
}

export interface CreateExchangeResponse {
  success: true;
  referenceId: string;
  fromAmount: number;
  toAmount: number;
}
