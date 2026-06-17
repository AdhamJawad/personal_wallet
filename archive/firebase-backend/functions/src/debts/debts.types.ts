export type DebtDirection = "owed_by_contact" | "owed_to_contact";

export type DebtStatus = "active" | "settled" | "cancelled";

export interface CreateDebtRequest {
  contactId: string;
  direction: string;
  currency: string;
  amount: number;
  description?: string;
}

export interface RecordDebtSettlementRequest {
  debtId: string;
  amount: number;
}

export interface GetDebtSettlementsRequest {
  debtId: string;
}

export interface DebtRecord {
  debtId: string;
  ownerUid: string;
  contactId: string;
  direction: DebtDirection;
  currency: string;
  originalAmount: number;
  remainingAmount: number;
  status: DebtStatus;
  description: string | null;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface DebtSettlementRecord {
  settlementId: string;
  debtId: string;
  ownerUid: string;
  amount: number;
  currency: string;
  createdAt?: Date;
}
