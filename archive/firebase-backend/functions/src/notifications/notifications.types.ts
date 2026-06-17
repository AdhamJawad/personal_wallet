export interface NotificationRecord {
  notificationId: string;
  ownerUid: string;
  type: string;
  title: string;
  body: string;
  isRead: boolean;
  metadata: Record<string, unknown>;
  createdAt?: Date;
}

export interface CreateNotificationInput {
  ownerUid: string;
  type: string;
  title: string;
  body: string;
  metadata: Record<string, unknown>;
}

export interface MarkNotificationAsReadRequest {
  notificationId: string;
}

export interface MarkNotificationAsReadResponse {
  success: true;
}
