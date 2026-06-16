export const APP_CONSTANTS = {
  region: "us-central1",
  runtime: {
    maxInstances: 10,
  },
  firestore: {
    collections: {
      authOtpChallenges: "authOtpChallenges",
      ledgerEntries: "ledgerEntries",
      phoneIndex: "phoneIndex",
      users: "users",
      wallets: "wallets",
    },
  },
  auth: {
    otp: {
      length: 6,
      expiresInMinutes: 5,
      cooldownSeconds: 60,
      maxAttempts: 5,
      statusPending: "pending",
      statusVerified: "verified",
      statusExpired: "expired",
      statusLocked: "locked",
    },
  },
  wallets: {
    defaultStatus: "active",
    defaultSupportedCurrencies: ["USD", "SYP"],
  },
  ledger: {
    entryTypes: [
      "deposit",
      "withdrawal",
      "transfer_in",
      "transfer_out",
      "exchange_in",
      "exchange_out",
      "debt_settlement_in",
      "debt_settlement_out",
    ],
  },
  headers: {
    sessionId: "x-session-id",
    deviceId: "x-device-id",
    requestId: "x-request-id",
  },
} as const;
