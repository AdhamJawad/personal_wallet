import * as logger from "firebase-functions/logger";

export const appLogger = {
  debug(message: string, context?: Record<string, unknown>): void {
    logger.debug(message, context);
  },
  info(message: string, context?: Record<string, unknown>): void {
    logger.info(message, context);
  },
  warn(message: string, context?: Record<string, unknown>): void {
    logger.warn(message, context);
  },
  error(message: string, context?: Record<string, unknown>): void {
    logger.error(message, context);
  },
};
