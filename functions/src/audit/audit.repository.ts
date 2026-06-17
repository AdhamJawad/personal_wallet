import {Timestamp} from "firebase-admin/firestore";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {db} from "../shared/firestore/firestore.client.js";
import type {
  AuditLogRecord,
  CreateAuditLogInput,
} from "./audit.types.js";

/**
 * Repository for audit log persistence operations.
 */
export class AuditRepository {
  /**
   * Creates an audit log document.
   * @param {CreateAuditLogInput} input Audit log payload.
   * @return {Promise<AuditLogRecord>} Created audit log record.
   */
  async createAuditLog(input: CreateAuditLogInput): Promise<AuditLogRecord> {
    const collectionName = APP_CONSTANTS.firestore.collections.auditLogs;
    const auditRef = db.collection(collectionName).doc();
    const createdAt = Timestamp.now();

    await auditRef.create({
      auditId: auditRef.id,
      ownerUid: input.ownerUid,
      entityType: input.entityType,
      entityId: input.entityId,
      action: input.action,
      metadata: input.metadata,
      createdAt,
    });

    return {
      auditId: auditRef.id,
      ownerUid: input.ownerUid,
      entityType: input.entityType,
      entityId: input.entityId,
      action: input.action,
      metadata: input.metadata,
      createdAt: createdAt.toDate(),
    };
  }

  /**
   * Returns audit logs owned by a user ordered by newest first.
   * @param {string} ownerUid Firebase Auth UID of the audit owner.
   * @return {Promise<AuditLogRecord[]>} Audit log records.
   */
  async getAuditLogsByOwner(ownerUid: string): Promise<AuditLogRecord[]> {
    const collectionName = APP_CONSTANTS.firestore.collections.auditLogs;
    const snapshot = await db.collection(collectionName)
      .where("ownerUid", "==", ownerUid)
      .orderBy("createdAt", "desc")
      .get();

    return snapshot.docs.map((document) => {
      const data = document.data();

      return {
        auditId: data.auditId as string,
        ownerUid: data.ownerUid as string,
        entityType: data.entityType as AuditLogRecord["entityType"],
        entityId: data.entityId as string,
        action: data.action as string,
        metadata: (data.metadata as Record<string, unknown>) ?? {},
        createdAt: this.toDate(data.createdAt),
      };
    });
  }

  /**
   * Converts Firestore timestamps and date-like values to Date.
   * @param {unknown} value Firestore timestamp-like value.
   * @return {Date | undefined} Converted date instance.
   */
  private toDate(value: unknown): Date | undefined {
    if (!value) {
      return undefined;
    }

    if (value instanceof Timestamp) {
      return value.toDate();
    }

    if (value instanceof Date) {
      return value;
    }

    return new Date(value as string);
  }
}
