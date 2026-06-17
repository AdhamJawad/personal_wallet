export const APP_CONSTANTS = {
  region: "us-central1",
  runtime: {
    maxInstances: 10,
  },
  firestore: {
    collections: {
      auditLogs: "auditLogs",
      authOtpChallenges: "authOtpChallenges",
      contacts: "contacts",
      debts: "debts",
      debtSettlements: "debtSettlements",
      ledgerEntries: "ledgerEntries",
      notifications: "notifications",
      phoneIndex: "phoneIndex",
      transfers: "transfers",
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
  debts: {
    directions: ["owed_by_contact", "owed_to_contact"],
    statuses: ["active", "settled", "cancelled"],
    defaultStatus: "active",
  },
  audit: {
    entityTypes: ["wallet", "debt", "contact", "transfer"],
  },
  transfers: {
    statuses: ["completed", "cancelled"],
    defaultStatus: "completed",
  },
  headers: {
    sessionId: "x-session-id",
    deviceId: "x-device-id",
    requestId: "x-request-id",
  },
} as const;
