import {Timestamp} from "firebase-admin/firestore";

import {APP_CONSTANTS} from "../shared/constants/app.constants.js";
import {db} from "../shared/firestore/firestore.client.js";
import type {ContactRecord} from "./contacts.types.js";

/**
 * Repository for contact persistence operations.
 */
export class ContactsRepository {
  /**
   * Creates a contact document.
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
    const collectionName = APP_CONSTANTS.firestore.collections.contacts;
    const contactRef = db.collection(collectionName).doc();
    const createdAt = Timestamp.now();

    await contactRef.create({
      contactId: contactRef.id,
      ownerUid,
      displayName,
      phoneNumber,
      linkedUserUid: null,
      createdAt,
      updatedAt: createdAt,
    });

    return {
      contactId: contactRef.id,
      ownerUid,
      displayName,
      phoneNumber,
      linkedUserUid: null,
      createdAt: createdAt.toDate(),
      updatedAt: createdAt.toDate(),
    };
  }

  /**
   * Returns a contact by its identifier.
   * @param {string} contactId Contact document ID.
   * @return {Promise<ContactRecord | null>} Contact record if it exists.
   */
  async getContactById(contactId: string): Promise<ContactRecord | null> {
    const collectionName = APP_CONSTANTS.firestore.collections.contacts;
    const snapshot = await db.collection(collectionName).doc(contactId).get();

    if (!snapshot.exists) {
      return null;
    }

    const data = snapshot.data();

    return {
      contactId: data?.contactId as string,
      ownerUid: data?.ownerUid as string,
      displayName: data?.displayName as string,
      phoneNumber: (data?.phoneNumber as string | null) ?? null,
      linkedUserUid: null,
      createdAt: this.toDate(data?.createdAt),
      updatedAt: this.toDate(data?.updatedAt),
    };
  }

  /**
   * Returns all contacts owned by a user ordered by creation time.
   * @param {string} ownerUid Firebase Auth UID of the contact owner.
   * @return {Promise<ContactRecord[]>} Contact records for the owner.
   */
  async getContactsByOwner(ownerUid: string): Promise<ContactRecord[]> {
    const collectionName = APP_CONSTANTS.firestore.collections.contacts;
    const snapshot = await db.collection(collectionName)
      .where("ownerUid", "==", ownerUid)
      .orderBy("createdAt", "asc")
      .get();

    return snapshot.docs.map((document) => {
      const data = document.data();

      return {
        contactId: data.contactId as string,
        ownerUid: data.ownerUid as string,
        displayName: data.displayName as string,
        phoneNumber: (data.phoneNumber as string | null) ?? null,
        linkedUserUid: null,
        createdAt: this.toDate(data.createdAt),
        updatedAt: this.toDate(data.updatedAt),
      };
    });
  }

  /**
   * Finds a possible duplicate contact for an owner.
   * @param {string} ownerUid Firebase Auth UID of the contact owner.
   * @param {string} displayName Contact display name.
   * @param {string | null} phoneNumber Optional contact phone number.
   * @return {Promise<ContactRecord | null>} Duplicate contact if found.
   */
  async findDuplicateContact(
    ownerUid: string,
    displayName: string,
    phoneNumber: string | null,
  ): Promise<ContactRecord | null> {
    const contacts = await this.getContactsByOwner(ownerUid);
    const normalizedName = displayName.trim().toLocaleLowerCase();

    const duplicate = contacts.find((contact) => {
      const contactName = contact.displayName.trim().toLocaleLowerCase();
      return contactName === normalizedName &&
        (contact.phoneNumber ?? null) === phoneNumber;
    });

    return duplicate ?? null;
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
