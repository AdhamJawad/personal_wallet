import {DebtsController} from "./debts.controller.js";

const debtsController = new DebtsController();

export const createDebt = debtsController.createDebt();
export const getDebts = debtsController.getDebts();
export const recordDebtSettlement = debtsController.recordDebtSettlement();
export const getDebtSettlements = debtsController.getDebtSettlements();
