String pastaSummaryLabel({
  required String name,
  required int quantity,
  String notes = '',
}) {
  final base = quantity > 1 ? '${quantity}x $name' : name;
  final trimmed = notes.trim();
  if (trimmed.isEmpty) return base;
  return '$base · $trimmed';
}
