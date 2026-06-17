import {TransfersController} from "./transfers.controller.js";

const transfersController = new TransfersController();

export const createUserTransfer = transfersController.createUserTransfer();
export const getTransfers = transfersController.getTransfers();
