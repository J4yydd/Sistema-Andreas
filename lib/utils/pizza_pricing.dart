/// Calcula el total según cantidad.
/// Pares aplican [promoPairPrice]; unidades sueltas usan [unitPrice].
double calculatePizzaTotal(
  int quantity,
  double unitPrice, {
  double? promoPairPrice,
}) {
  if (quantity <= 0) return 0;
  if (promoPairPrice == null) return quantity * unitPrice;

  final pairs = quantity ~/ 2;
  final remainder = quantity % 2;
  return (pairs * promoPairPrice) + (remainder * unitPrice);
}
