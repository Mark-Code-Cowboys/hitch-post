const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "Jun 15, 2026" — the ledger's date style, no intl dependency.
String formatDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

/// "Jun 12 – 15, 2026" (or the long form across months/years).
String formatDateRange(DateTime a, DateTime b) {
  if (a.year == b.year && a.month == b.month) {
    return '${formatDate(a).split(',').first} – ${b.day}, ${a.year}';
  }
  return '${formatDate(a)} – ${formatDate(b)}';
}
