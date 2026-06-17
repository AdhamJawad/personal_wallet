export type TransferStatus = "completed" | "cancelled";

export interface CreateUserTransferRequest {
  sourceWalletId: string;
  destinationWalletId: string;
  amount: number;
  currency: string;
}

export interface CreateUserTransferInput {
  senderUid: string;
  sourceWalletId: string;
  destinationWalletId: string;
  amount: number;
  currency: string;
}

export interface CreateUserTransferResponse {
  success: true;
  transferId: string;
}

export interface TransferRecord {
  transferId: string;
  senderUid: string;
  receiverUid: string;
  sourceWalletId: string;
  destinationWalletId: string;
  currency: string;
  amount: number;
  status: TransferStatus;
  createdAt?: Date;
}
