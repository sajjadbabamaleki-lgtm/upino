/**
 * Civil-time helpers. Every date-sensitive calculation resolves in the user's
 * own timezone (§5). A due date becomes overdue at local midnight, never at
 * 00:00 UTC — see fixture T12.
 */

/** An instant in time, epoch milliseconds. */
export type Instant = number;

/** A civil date with no time or zone attached, rendered as `YYYY-MM-DD`. */
export type LocalDate = string & { readonly __localDate: unique symbol };

const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/;

export function localDate(value: string): LocalDate {
  if (!ISO_DATE.test(value)) throw new Error(`Malformed local date: ${value}`);
  return value as LocalDate;
}

const formatters = new Map<string, Intl.DateTimeFormat>();

function formatterFor(timeZone: string): Intl.DateTimeFormat {
  let f = formatters.get(timeZone);
  if (!f) {
    f = new Intl.DateTimeFormat('en-US', {
      timeZone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    });
    formatters.set(timeZone, f);
  }
  return f;
}

/** Resolve an instant to the civil date observed in `timeZone`. */
export function toLocalDate(at: Instant, timeZone: string): LocalDate {
  const parts = formatterFor(timeZone).formatToParts(new Date(at));
  const get = (t: Intl.DateTimeFormatPartTypes): string => {
    const p = parts.find((x) => x.type === t);
    if (!p) throw new Error(`Timezone ${timeZone} produced no ${t} part`);
    return p.value;
  };
  return localDate(`${get('year')}-${get('month')}-${get('day')}`);
}

/** `YYYY-MM-DD` sorts lexicographically, which matches chronological order. */
export function compareDates(a: LocalDate, b: LocalDate): -1 | 0 | 1 {
  return a < b ? -1 : a > b ? 1 : 0;
}

export const isBefore = (a: LocalDate, b: LocalDate): boolean => a < b;
export const isAfter = (a: LocalDate, b: LocalDate): boolean => a > b;
export const isOnOrBefore = (a: LocalDate, b: LocalDate): boolean => a <= b;

/**
 * A claim is overdue once its due date has fully passed in the user's own
 * timezone: due on the 1st means overdue from local midnight starting the 2nd.
 */
export const isOverdue = (dueDate: LocalDate, today: LocalDate): boolean => today > dueDate;
