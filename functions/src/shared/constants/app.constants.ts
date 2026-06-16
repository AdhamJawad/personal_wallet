export const APP_CONSTANTS = {
  region: "us-central1",
  runtime: {
    maxInstances: 10,
  },
  headers: {
    sessionId: "x-session-id",
    deviceId: "x-device-id",
    requestId: "x-request-id",
  },
} as const;
