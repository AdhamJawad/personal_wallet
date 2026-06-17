import {AttachmentsController} from "./attachments.controller.js";

const attachmentsController = new AttachmentsController();

export const createAttachmentUploadUrl =
  attachmentsController.createAttachmentUploadUrl();
export const completeAttachmentUpload =
  attachmentsController.completeAttachmentUpload();
export const getAttachments = attachmentsController.getAttachments();
