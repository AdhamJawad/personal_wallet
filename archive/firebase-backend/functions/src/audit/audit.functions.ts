import {AuditController} from "./audit.controller.js";

const auditController = new AuditController();

export const getAuditLogs = auditController.getAuditLogs();
