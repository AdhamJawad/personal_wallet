import {WalletsController} from "./wallets.controller.js";

const walletsController = new WalletsController();

export const createDeposit = walletsController.createDeposit();
export const createExchange = walletsController.createExchange();
export const createInternalTransfer =
  walletsController.createInternalTransfer();
export const createWallet = walletsController.createWallet();
export const getWallets = walletsController.getWallets();
export const getWalletBalances = walletsController.getWalletBalances();
export const getWalletLedger = walletsController.getWalletLedger();
