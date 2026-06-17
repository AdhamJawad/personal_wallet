import {CallableRequest, HttpsError, onCall} from "firebase-functions/https";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {AppError} from "../shared/errors/app.error.js";
import {appLogger} from "../shared/utils/logger.js";
import {AuditUnauthorizedAccessError} from "./audit.errors.js";
import {AuditService} from "./audit.service.js";
import type {AuditLogRecord} from "./audit.types.js";

/**
 * Controller for the audit module.
 */
export class AuditController {
  /**
   * Creates an audit controller instance.
   * @param {AuditService} auditService Audit service dependency.
   */
  constructor(
    private readonly auditService: AuditService = new AuditService(),
  ) {}

  /**
   * Returns audit logs owned by the authenticated user.
   * @return {unknown} Callable Firebase function handler.
   */
  getAuditLogs() {
    return onCall(
      {region: APP_CONSTANTS.region},
      async (request): Promise<AuditLogRecord[]> => {
        const ownerUid = this.requireAuthenticatedUid(request);

        appLogger.info("Get audit logs request received.", {
          event: "audit.list.requested",
          ownerUid,
        });

        try {
          return await this.auditService.getAuditLogs(ownerUid);
        } catch (error) {
          appLogger.error("Get audit logs request failed.", {
            event: "audit.list.error",
            ownerUid,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to load audit logs.");
        }
      },
    );
  }

  /**
   * Extracts the authenticated Firebase UID from the callable request.
   * @param {CallableRequest<unknown>} request Callable request.
   * @return {string} Authenticated Firebase UID.
   */
  private requireAuthenticatedUid(request: CallableRequest<unknown>): string {
    const uid = request.auth?.uid;

    if (!uid) {
      throw new AuditUnauthorizedAccessError();
    }

    return uid;
  }

  /**
   * Maps internal application errors to callable HTTPS errors.
   * @param {unknown} error Error raised by the audit layer.
   * @param {string} fallbackMessage Fallback error message.
   * @return {HttpsError} Callable-friendly error response.
   */
  private toHttpsError(error: unknown, fallbackMessage: string): HttpsError {
    if (error instanceof HttpsError) {
      return error;
    }

    if (error instanceof AuditUnauthorizedAccessError) {
      return new HttpsError("unauthenticated", error.message, error.details);
    }

    if (error instanceof AppError) {
      return new HttpsError("internal", error.message, error.details);
    }

    return new HttpsError("internal", fallbackMessage);
  }
}
