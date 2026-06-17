export interface SendOtpRequest {
  phoneNumber: string;
}

export interface VerifyOtpRequest {
  phoneNumber: string;
  otp: string;
}

export interface PhoneIndexRecord {
  uid: string;
  phoneNumber: string;
  createdAt?: Date;
}

export interface UserProfileRecord {
  uid: string;
  phoneNumber: string;
  displayName: null;
  emailAddress: null;
  profileImageUrl: null;
  status: "active";
  createdAt?: Date;
  updatedAt?: Date;
}

export type OtpChallengeStatus =
  | "pending"
  | "expired"
  | "locked"
  | "verified";

export type OtpChallengeExpireReason = "superseded" | "ttl_expired";

export interface CreateOtpChallengeInput {
  phoneNumber: string;
  otpHash: string;
  expiresAt: Date;
  attempts: number;
  status: "pending";
}

export interface OtpChallengeRecord {
  id: string;
  phoneNumber: string;
  otpHash: string;
  expiresAt: Date;
  createdAt: Date;
  attempts: number;
  status: OtpChallengeStatus;
  expiredAt?: Date;
  expireReason?: OtpChallengeExpireReason;
  lockedAt?: Date;
  verifiedAt?: Date;
}

export interface SendOtpCreatedResult {
  challengeId: string;
  expiresAt: string;
  status: "pending";
}

export interface SendOtpAlreadySentResult {
  status: "otp_already_sent";
  retryAfterSeconds: number;
}

export type SendOtpResult = SendOtpCreatedResult | SendOtpAlreadySentResult;

export interface VerifyOtpResult {
  status: "verified";
  isNewUser: boolean;
  uid: string;
  customToken: string;
  profile: UserProfileRecord;
}
