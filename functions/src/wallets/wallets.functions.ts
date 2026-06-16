import {WalletsController} from "./wallets.controller.js";

const walletsController = new WalletsController();

export const createWallet = walletsController.createWallet();
export const getWallets = walletsController.getWallets();
export const getWalletBalances = walletsController.getWalletBalances();
export const getWalletLedger = walletsController.getWalletLedger();
