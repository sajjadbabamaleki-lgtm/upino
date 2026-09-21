/// Civil-time helpers. Every date-sensitive calculation resolves in the user's
/// own timezone (§5): a due date turns overdue at local midnight, never at
/// 00:00 UTC.
library;

/// A civil date with no time or zone attached.
class LocalDate implements Comparable<LocalDate> {
  const LocalDate(this.year, this.month, this.day);

  factory LocalDate.parse(String iso) {
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(iso);
    if (m == null) throw ArgumentError('Malformed local date: $iso');
    return LocalDate(
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
    );
  }

  /// Resolve an instant to the civil date observed in [offset].
  ///
  /// Dart has no IANA timezone database in the core SDK, so the zone is
  /// supplied as the offset in effect at that instant. Callers holding a real
  /// IANA zone resolve the offset first; this keeps the engine free of a
  /// timezone dependency while preserving local-midnight semantics.
  factory LocalDate.at(DateTime instant, Duration offset) {
    final shifted = instant.toUtc().add(offset);
    return LocalDate(shifted.year, shifted.month, shifted.day);
  }

  final int year;
  final int month;
  final int day;

  LocalDate addDays(int days) {
    final d = DateTime.utc(year, month, day).add(Duration(days: days));
    return LocalDate(d.year, d.month, d.day);
  }

  int differenceInDays(LocalDate other) =>
      DateTime.utc(year, month, day)
          .difference(DateTime.utc(other.year, other.month, other.day))
          .inDays;

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  bool operator <(LocalDate other) => compareTo(other) < 0;
  bool operator >(LocalDate other) => compareTo(other) > 0;
  bool operator <=(LocalDate other) => compareTo(other) <= 0;
  bool operator >=(LocalDate other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => '${year.toString().padLeft(4, '0')}'
      '-${month.toString().padLeft(2, '0')}'
      '-${day.toString().padLeft(2, '0')}';
}

/// A claim is overdue once its due date has fully passed locally: due on the
/// 1st means overdue from local midnight starting the 2nd.
bool isOverdue(LocalDate dueDate, LocalDate today) => today > dueDate;
