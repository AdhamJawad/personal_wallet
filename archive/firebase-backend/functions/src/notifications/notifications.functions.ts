import {NotificationsController} from "./notifications.controller.js";

const notificationsController = new NotificationsController();

export const getNotifications = notificationsController.getNotifications();
export const markNotificationAsRead =
  notificationsController.markNotificationAsRead();
