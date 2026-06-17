export interface CreateContactRequest {
  displayName: string;
  phoneNumber?: string;
}

export interface ContactRecord {
  contactId: string;
  ownerUid: string;
  displayName: string;
  phoneNumber: string | null;
  linkedUserUid: null;
  createdAt?: Date;
  updatedAt?: Date;
}
