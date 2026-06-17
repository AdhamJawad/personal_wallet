export type AuditEntityType = "wallet" | "debt" | "contact" | "transfer";

export interface CreateAuditLogInput {
  ownerUid: string;
  entityType: AuditEntityType;
  entityId: string;
  action: string;
  metadata: Record<string, unknown>;
}

export interface AuditLogRecord {
  auditId: string;
  ownerUid: string;
  entityType: AuditEntityType;
  entityId: string;
  action: string;
  metadata: Record<string, unknown>;
  createdAt?: Date;
}
