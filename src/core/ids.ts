declare const brand: unique symbol;
type Brand<T, B extends string> = T & { readonly [brand]: B };

export type AccountId = Brand<string, 'AccountId'>;
export type CardId = Brand<string, 'CardId'>;
export type DebtId = Brand<string, 'DebtId'>;
export type EventId = Brand<string, 'EventId'>;
export type CanonicalEventId = Brand<string, 'CanonicalEventId'>;
export type ClaimId = Brand<string, 'ClaimId'>;
export type ReservationId = Brand<string, 'ReservationId'>;
export type SnapshotId = Brand<string, 'SnapshotId'>;
export type IncomeEventId = Brand<string, 'IncomeEventId'>;

export const accountId = (s: string): AccountId => s as AccountId;
export const cardId = (s: string): CardId => s as CardId;
export const debtId = (s: string): DebtId => s as DebtId;
export const eventId = (s: string): EventId => s as EventId;
export const canonicalEventId = (s: string): CanonicalEventId => s as CanonicalEventId;
export const claimId = (s: string): ClaimId => s as ClaimId;
export const reservationId = (s: string): ReservationId => s as ReservationId;
export const snapshotId = (s: string): SnapshotId => s as SnapshotId;
export const incomeEventId = (s: string): IncomeEventId => s as IncomeEventId;
