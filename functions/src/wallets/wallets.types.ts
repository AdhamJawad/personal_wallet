export interface CreateWalletRequest {
  name: string;
}

export interface GetWalletLedgerRequest {
  walletId: string;
}

export interface GetWalletBalancesRequest {
  walletId: string;
}

export interface WalletBalancesResponse {
  walletId: string;
  balances: Record<string, number>;
}

export interface WalletRecord {
  walletId: string;
  ownerUid: string;
  name: string;
  status: "active";
  supportedCurrencies: string[];
  createdAt?: Date;
  updatedAt?: Date;
}
