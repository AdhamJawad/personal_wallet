import {ContactsController} from "./contacts.controller.js";

const contactsController = new ContactsController();

export const createContact = contactsController.createContact();
export const getContacts = contactsController.getContacts();
