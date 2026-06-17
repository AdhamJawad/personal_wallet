import {AuthController} from "./auth.controller.js";

const authController = new AuthController();

export const sendOtp = authController.sendOtp();
export const verifyOtp = authController.verifyOtp();
