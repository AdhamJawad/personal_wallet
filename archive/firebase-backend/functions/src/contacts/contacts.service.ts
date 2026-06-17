import {AuditService} from "../audit/audit.service.js";
import {appLogger} from "../shared/utils/logger.js";
import {DuplicateContactError} from "./contacts.errors.js";
import {ContactsRepository} from "./contacts.repository.js";
import type {ContactRecord} from "./contacts.types.js";

/**
 * Service for contact workflows.
 */
export class ContactsService {
  /**
   * Creates a contacts service instance.
   * @param {ContactsRepository} contactsRepository
   * Contact repository dependency.
   */
  constructor(
    private readonly contactsRepository: ContactsRepository =
    new ContactsRepository(),
    private readonly auditService: AuditService = new AuditService(),
  ) {}

  /**
   * Creates a contact for the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the contact owner.
   * @param {string} displayName Contact display name.
   * @param {string | null} phoneNumber Optional contact phone number.
   * @return {Promise<ContactRecord>} Created contact record.
   */
  async createContact(
    ownerUid: string,
    displayName: string,
    phoneNumber: string | null,
  ): Promise<ContactRecord> {
    const duplicate = await this.contactsRepository.findDuplicateContact(
      ownerUid,
      displayName,
      phoneNumber,
    );

    if (duplicate) {
      appLogger.warn("Duplicate contact creation blocked.", {
        event: "contacts.create.duplicate",
        ownerUid,
        displayName,
        phoneNumber,
        contactId: duplicate.contactId,
      });
      throw new DuplicateContactError();
    }

    const contact = await this.contactsRepository.createContact(
      ownerUid,
      displayName,
      phoneNumber,
    );

    appLogger.info("Contact created successfully.", {
      event: "contacts.create.completed",
      ownerUid,
      contactId: contact.contactId,
    });

    await this.auditService.createAuditLogSafely(
      {
        ownerUid,
        entityType: "contact",
        entityId: contact.contactId,
        action: "contact_created",
        metadata: {},
      },
      {
        sourceEvent: "contacts.create.completed",
        contactId: contact.contactId,
      },
    );

    return contact;
  }

  /**
   * Returns contacts owned by the authenticated user.
   * @param {string} ownerUid Firebase Auth UID of the contact owner.
   * @return {Promise<ContactRecord[]>} Contact records.
   */
  async getContacts(ownerUid: string): Promise<ContactRecord[]> {
    return this.contactsRepository.getContactsByOwner(ownerUid);
  }
}
