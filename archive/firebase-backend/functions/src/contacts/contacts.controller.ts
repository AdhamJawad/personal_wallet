import {CallableRequest, HttpsError, onCall} from "firebase-functions/https";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {AppError} from "../shared/errors/app.error.js";
import {ValidationError} from "../shared/errors/validation.error.js";
import {appLogger} from "../shared/utils/logger.js";
import {
  isValidPhoneNumber,
  normalizePhoneNumber,
} from "../shared/utils/phone.js";
import {
  ContactUnauthenticatedError,
  DuplicateContactError,
  InvalidContactNameError,
} from "./contacts.errors.js";
import {ContactsService} from "./contacts.service.js";
import type {ContactRecord, CreateContactRequest} from "./contacts.types.js";

/**
 * Controller for the contacts module.
 */
export class ContactsController {
  /**
   * Creates a contacts controller instance.
   * @param {ContactsService} contactsService Contact service dependency.
   */
  constructor(
    private readonly contactsService: ContactsService = new ContactsService(),
  ) {}

  /**
   * Creates a contact for the authenticated user.
   * @return {unknown} Callable Firebase function handler.
   */
  createContact() {
    return onCall<CreateContactRequest>(
      {region: APP_CONSTANTS.region},
      async (request): Promise<ContactRecord> => {
        const ownerUid = this.requireAuthenticatedUid(request);
        const payload = this.validateCreateContactRequest(request.data);

        appLogger.info("Create contact request received.", {
          event: "contacts.create.requested",
          ownerUid,
          hasPhoneNumber: payload.phoneNumber !== null,
        });

        try {
          return await this.contactsService.createContact(
            ownerUid,
            payload.displayName,
            payload.phoneNumber,
          );
        } catch (error) {
          appLogger.error("Create contact request failed.", {
            event: "contacts.create.error",
            ownerUid,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to create contact.");
        }
      },
    );
  }

  /**
   * Returns contacts owned by the authenticated user.
   * @return {unknown} Callable Firebase function handler.
   */
  getContacts() {
    return onCall(
      {region: APP_CONSTANTS.region},
      async (request): Promise<ContactRecord[]> => {
        const ownerUid = this.requireAuthenticatedUid(request);

        appLogger.info("Get contacts request received.", {
          event: "contacts.list.requested",
          ownerUid,
        });

        try {
          return await this.contactsService.getContacts(ownerUid);
        } catch (error) {
          appLogger.error("Get contacts request failed.", {
            event: "contacts.list.error",
            ownerUid,
            error: error instanceof Error ? error.message : "unknown_error",
          });
          throw this.toHttpsError(error, "Failed to load contacts.");
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
      throw new ContactUnauthenticatedError();
    }

    return uid;
  }

  /**
   * Validates the create contact request payload.
   * @param {CreateContactRequest | undefined} data Callable request payload.
   * @return {object} Normalized contact payload.
   */
  private validateCreateContactRequest(
    data: CreateContactRequest | undefined,
  ): {displayName: string; phoneNumber: string | null} {
    if (typeof data?.displayName !== "string") {
      throw new InvalidContactNameError();
    }

    const displayName = data.displayName.trim();

    if (!displayName) {
      throw new InvalidContactNameError();
    }

    if (typeof data.phoneNumber === "undefined") {
      return {
        displayName,
        phoneNumber: null,
      };
    }

    if (typeof data.phoneNumber !== "string") {
      throw new ValidationError("A valid phone number is required.", {
        field: "phoneNumber",
      });
    }

    const phoneNumber = normalizePhoneNumber(data.phoneNumber);

    if (!isValidPhoneNumber(phoneNumber)) {
      throw new ValidationError(
        "Phone number must be a valid E.164 value.",
        {field: "phoneNumber"},
      );
    }

    return {
      displayName,
      phoneNumber,
    };
  }

  /**
   * Maps internal application errors to callable HTTPS errors.
   * @param {unknown} error Error raised by the contacts layer.
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

    if (error instanceof InvalidContactNameError) {
      return new HttpsError("invalid-argument", error.message, error.details);
    }

    if (error instanceof DuplicateContactError) {
      return new HttpsError("already-exists", error.message, error.details);
    }

    if (error instanceof ContactUnauthenticatedError) {
      return new HttpsError("unauthenticated", error.message, error.details);
    }

    if (error instanceof AppError) {
      return new HttpsError("internal", error.message, error.details);
    }

    return new HttpsError("internal", fallbackMessage);
  }
}
