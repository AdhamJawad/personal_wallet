import {CallableRequest, HttpsError, onCall} from "firebase-functions/https";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {AppError} from "../shared/errors/app.error.js";
import {ValidationError} from "../shared/errors/validation.error.js";
import {appLogger} from "../shared/utils/logger.js";
import {
  NotificationNotFoundError,
  NotificationUnauthenticatedError,
  UnauthorizedNotificationAccessError,
} from "./notifications.errors.js";
import {NotificationsService} from "./notifications.service.js";
import type {
  MarkNotificationAsReadRequest,
  MarkNotificationAsReadResponse,
  NotificationRecord,
} from "./notifications.types.js";

/**
 * Controller for the notifications module.
 */
export class NotificationsController {
  /**
   * Creates a notifications controller instance.
   * @param {NotificationsService} notificationsService
   * Notification service dependency.
   */
  constructor(
    private readonly notificationsService: NotificationsService =
    new NotificationsService(),
  ) {}

  /**
   * Returns notifications owned by the authenticated user.
   * @return {unknown} Callable Firebase function handler.
   */
  getNotifications() {
    return onCall(
      {region: APP_CONSTANTS.region},
      async (request): Promise<NotificationRecord[]> => {
        const ownerUid = this.requireAuthenticatedUid(request);

        appLogger.info("Get notifications request received.", {
          event: "notifications.list.requested",
          ownerUid,
        });

        try {
          return await this.notificationsService.getNotifications(ownerUid);
        } catch (error) {
          appLogger.error("Get notifications request failed.", {
            event: "notifications.list.error",
            ownerUid,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to load notifications.");
        }
      },
    );
  }

  /**
   * Marks an owned notification as read.
   * @return {unknown} Callable Firebase function handler.
   */
  markNotificationAsRead() {
    return onCall<MarkNotificationAsReadRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<MarkNotificationAsReadResponse> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const notificationId = this.validateNotificationId(
          request.data?.notificationId,
        );

        appLogger.info("Mark notification as read request received.", {
          event: "notifications.mark_read.requested",
          ownerUid,
          notificationId,
        });

        try {
          await this.notificationsService.markNotificationAsRead(
            ownerUid,
            notificationId,
          );

          return {success: true};
        } catch (error) {
          appLogger.error("Mark notification as read request failed.", {
            event: "notifications.mark_read.error",
            ownerUid,
            notificationId,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(
            error,
            "Failed to mark notification as read.",
          );
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
      throw new NotificationUnauthenticatedError();
    }

    return uid;
  }

  /**
   * Validates a notification identifier input.
   * @param {unknown} notificationId Candidate notification identifier.
   * @return {string} Normalized notification identifier.
   */
  private validateNotificationId(notificationId: unknown): string {
    if (typeof notificationId !== "string") {
      throw new ValidationError("A valid notificationId is required.", {
        field: "notificationId",
      });
    }

    const normalizedNotificationId = notificationId.trim();

    if (!normalizedNotificationId) {
      throw new ValidationError("notificationId is required.", {
        field: "notificationId",
      });
    }

    return normalizedNotificationId;
  }

  /**
   * Maps internal application errors to callable HTTPS errors.
   * @param {unknown} error Error raised by the notifications layer.
   * @param {string} fallbackMessage Fallback error message.
   * @return {HttpsError} Callable-friendly error response.
   */
  private toHttpsError(error: unknown, fallbackMessage: string): HttpsError {
    if (error instanceof HttpsError) {
      return error;
    }

    if (error instanceof ValidationError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof NotificationUnauthenticatedError) {
      return new HttpsError("unauthenticated", error.message, error.details);
    }

    if (error instanceof NotificationNotFoundError) {
      return new HttpsError("not-found", error.message, error.details);
    }

    if (error instanceof UnauthorizedNotificationAccessError) {
      return new HttpsError("permission-denied", error.message, error.details);
    }

    if (error instanceof AppError) {
      return new HttpsError("internal", error.message, error.details);
    }

    return new HttpsError("internal", fallbackMessage);
  }
}
