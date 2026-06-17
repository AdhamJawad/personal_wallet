import {Timestamp} from "firebase-admin/firestore";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {db} from "../shared/firestore/firestore.client.js";
import type {
  CreateNotificationInput,
  NotificationRecord,
} from "./notifications.types.js";

/**
 * Repository for notification persistence operations.
 */
export class NotificationsRepository {
  /**
   * Creates a notification document.
   * @param {CreateNotificationInput} input Notification payload.
   * @return {Promise<NotificationRecord>} Created notification record.
   */
  async createNotification(
    input: CreateNotificationInput,
  ): Promise<NotificationRecord> {
    const collectionName = APP_CONSTANTS.firestore.collections.notifications;
    const notificationRef = db.collection(collectionName).doc();
    const createdAt = Timestamp.now();

    await notificationRef.create({
      notificationId: notificationRef.id,
      ownerUid: input.ownerUid,
      type: input.type,
      title: input.title,
      body: input.body,
      isRead: false,
      metadata: input.metadata,
      createdAt,
    });

    return {
      notificationId: notificationRef.id,
      ownerUid: input.ownerUid,
      type: input.type,
      title: input.title,
      body: input.body,
      isRead: false,
      metadata: input.metadata,
      createdAt: createdAt.toDate(),
    };
  }

  /**
   * Returns notifications owned by a user ordered by newest first.
   * @param {string} ownerUid Firebase Auth UID of the notification owner.
   * @return {Promise<NotificationRecord[]>} Notification records.
   */
  async getNotificationsByOwner(
    ownerUid: string,
  ): Promise<NotificationRecord[]> {
    const collectionName = APP_CONSTANTS.firestore.collections.notifications;
    const snapshot = await db.collection(collectionName)
      .where("ownerUid", "==", ownerUid)
      .orderBy("createdAt", "desc")
      .get();

    return snapshot.docs.map((document) => {
      const data = document.data();

      return {
        notificationId: data.notificationId as string,
        ownerUid: data.ownerUid as string,
        type: data.type as string,
        title: data.title as string,
        body: data.body as string,
        isRead: data.isRead as boolean,
        metadata: (data.metadata as Record<string, unknown>) ?? {},
        createdAt: this.toDate(data.createdAt),
      };
    });
  }

  /**
   * Returns a notification by its identifier.
   * @param {string} notificationId Notification document ID.
   * @return {Promise<NotificationRecord | null>} Notification record if found.
   */
  async getNotificationById(
    notificationId: string,
  ): Promise<NotificationRecord | null> {
    const collectionName = APP_CONSTANTS.firestore.collections.notifications;
    const snapshot = await db.collection(collectionName)
      .doc(notificationId)
      .get();

    if (!snapshot.exists) {
      return null;
    }

    const data = snapshot.data();

    return {
      notificationId: data?.notificationId as string,
      ownerUid: data?.ownerUid as string,
      type: data?.type as string,
      title: data?.title as string,
      body: data?.body as string,
      isRead: data?.isRead as boolean,
      metadata: (data?.metadata as Record<string, unknown>) ?? {},
      createdAt: this.toDate(data?.createdAt),
    };
  }

  /**
   * Marks a notification as read.
   * @param {string} notificationId Notification document ID.
   * @return {Promise<void>} Resolves when the update completes.
   */
  async markNotificationAsRead(notificationId: string): Promise<void> {
    const collectionName = APP_CONSTANTS.firestore.collections.notifications;
    await db.collection(collectionName).doc(notificationId).update({
      isRead: true,
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
