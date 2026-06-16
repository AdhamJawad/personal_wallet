const E164_PHONE_PATTERN = /^\+[1-9]\d{7,14}$/;

/**
 * Normalizes a phone number string before validation and storage.
 * @param {string} value Raw phone number input.
 * @return {string} Normalized phone number.
 */
export function normalizePhoneNumber(value: string): string {
  return value.trim().replace(/\s+/g, "");
}

/**
 * Checks whether a normalized phone number matches E.164.
 * @param {string} value Normalized phone number.
 * @return {boolean} True when the phone number is valid.
 */
export function isValidPhoneNumber(value: string): boolean {
  return E164_PHONE_PATTERN.test(value);
}

/**
 * Masks a phone number for structured logs.
 * @param {string} value Normalized phone number.
 * @return {string} Masked phone number.
 */
export function maskPhoneNumber(value: string): string {
  if (value.length <= 4) {
    return "****";
  }

  const visibleSuffix = value.slice(-4);
  return `***${visibleSuffix}`;
}
