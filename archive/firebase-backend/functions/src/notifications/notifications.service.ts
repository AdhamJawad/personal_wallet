import {appLogger} from "../shared/utils/logger.js";
import {
  NotificationNotFoundError,
  UnauthorizedNotificationAccessError,
} from "./notifications.errors.js";
import {NotificationsRepository} from "./notifications.repository.js";
import type {
  CreateNotificationInput,
  NotificationRecord,
} from "./notifications.types.js";

/**
 * Service for notification workflows.
 */
export class NotificationsService {
  /**
   * Creates a notifications service instance.
   * @param {NotificationsRepository} notificationsRepository
   * Notification repository dependency.
   */
  constructor(
    private readonly notificationsRepository: NotificationsRepository =
    new NotificationsRepository(),
  ) {}

  /**
   * Creates a notification record.
   * @param {CreateNotificationInput} input Notification payload.
   * @return {Promise<NotificationRecord>} Created notification record.
   */
  async createNotification(
    input: CreateNotificationInput,
  ): Promise<NotificationRecord> {
    const notification =
      await this.notificationsRepository.createNotification(input);

    appLogger.info("Notification created successfully.", {
      event: "notifications.create.completed",
      ownerUid: input.ownerUid,
      notificationId: notification.notificationId,
      type: input.type,
    });

    return notification;
  }

  /**
   * Creates a notification without throwing on failure.
   * @param {CreateNotificationInput} input Notification payload.
   * @param {Record<string, unknown>=} context Optional failure log context.
   * @return {Promise<void>} Resolves after the notification attempt completes.
   */
  async createNotificationSafely(
    input: CreateNotificationInput,
    context?: Record<string, unknown>,
  ): Promise<void> {
    try {
      await this.createNotification(input);
    } catch (error) {
      appLogger.error("Notification creation failed.", {
        event: "notifications.create.failed",
        ownerUid: input.ownerUid,
        type: input.type,
        ...context,
        error: error instanceof Error ? error.message : "unknown_error",
      });
    }
  }

  /**
   * Returns notifications owned by the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the notification owner.
   * @return {Promise<NotificationRecord[]>} Notification records.
   */
  async getNotifications(ownerUid: string): Promise<NotificationRecord[]> {
    return this.notificationsRepository.getNotificationsByOwner(ownerUid);
  }

  /**
   * Marks an owned notification as read.
   * @param {string} ownerUid Firebase Auth UID of the notification owner.
   * @param {string} notificationId Notification document ID.
   * @return {Promise<void>} Resolves when the update completes.
   */
  async markNotificationAsRead(
    ownerUid: string,
    notificationId: string,
  ): Promise<void> {
    const notification = await this.notificationsRepository.getNotificationById(
      notificationId,
    );

    if (!notification) {
      appLogger.warn("Notification not found.", {
        event: "notifications.mark_read.not_found",
        ownerUid,
        notificationId,
      });
      throw new NotificationNotFoundError();
    }

    if (notification.ownerUid !== ownerUid) {
      appLogger.warn("Unauthorized notification access denied.", {
        event: "notifications.mark_read.unauthorized",
        ownerUid,
        notificationId,
        notificationOwnerUid: notification.ownerUid,
      });
      throw new UnauthorizedNotificationAccessError();
    }

    await this.notificationsRepository.markNotificationAsRead(notificationId);

    appLogger.info("Notification marked as read.", {
      event: "notifications.mark_read.completed",
      ownerUid,
      notificationId,
    });
  }
}
