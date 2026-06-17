import {appLogger} from "../shared/utils/logger.js";
import {AuditRepository} from "./audit.repository.js";
import type {
  AuditLogRecord,
  CreateAuditLogInput,
} from "./audit.types.js";

/**
 * Service for audit log workflows.
 */
export class AuditService {
  /**
   * Creates an audit service instance.
   * @param {AuditRepository} auditRepository Audit repository dependency.
   */
  constructor(
    private readonly auditRepository: AuditRepository = new AuditRepository(),
  ) {}

  /**
   * Creates an audit log record.
   * @param {CreateAuditLogInput} input Audit log payload.
   * @return {Promise<AuditLogRecord>} Created audit log record.
   */
  async createAuditLog(input: CreateAuditLogInput): Promise<AuditLogRecord> {
    const auditLog = await this.auditRepository.createAuditLog(input);

    appLogger.info("Audit log created successfully.", {
      event: "audit.create.completed",
      ownerUid: input.ownerUid,
      auditId: auditLog.auditId,
      entityType: input.entityType,
      entityId: input.entityId,
      action: input.action,
    });

    return auditLog;
  }

  /**
   * Creates an audit log record without throwing on failure.
   * @param {CreateAuditLogInput} input Audit log payload.
   * @param {Record<string, unknown>=} context
   * Optional logging context for failure diagnostics.
   * @return {Promise<void>} Resolves after the audit attempt completes.
   */
  async createAuditLogSafely(
    input: CreateAuditLogInput,
    context?: Record<string, unknown>,
  ): Promise<void> {
    try {
      await this.createAuditLog(input);
    } catch (error) {
      appLogger.error("Audit log creation failed.", {
        event: "audit.create.failed",
        ownerUid: input.ownerUid,
        entityType: input.entityType,
        entityId: input.entityId,
        action: input.action,
        ...context,
        error: error instanceof Error ? error.message : "unknown_error",
      });
    }
  }

  /**
   * Returns audit logs owned by the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the audit owner.
   * @return {Promise<AuditLogRecord[]>} Audit log records.
   */
  async getAuditLogs(ownerUid: string): Promise<AuditLogRecord[]> {
    return this.auditRepository.getAuditLogsByOwner(ownerUid);
  }
}
