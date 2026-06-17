import {AppError} from "../shared/errors/app.error.js";

/**
 * Error raised when an authenticated Firebase user is required.
 */
export class NotificationUnauthenticatedError extends AppError {
  /**
   * Creates an unauthenticated notification access error.
   */
  constructor() {
    super("Authentication is required.", "unauthenticated", 401);
    this.name = "NotificationUnauthenticatedError";
  }
}

/**
 * Error raised when a notification cannot be found.
 */
export class NotificationNotFoundError extends AppError {
  /**
   * Creates a notification not found error.
   */
  constructor() {
    super("Notification not found.", "internal", 404);
    this.name = "NotificationNotFoundError";
  }
}

/**
 * Error raised when a notification is not owned by the authenticated user.
 */
export class UnauthorizedNotificationAccessError extends AppError {
  /**
   * Creates an unauthorized notification access error.
   */
  constructor() {
    super(
      "You do not have access to this notification.",
      "forbidden",
      403,
    );
    this.name = "UnauthorizedNotificationAccessError";
  }
}
