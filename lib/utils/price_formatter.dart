String formatPrice(double amount) {
  if (amount == amount.roundToDouble()) {
    return '\$${amount.round()}';
  }
  return '\$${amount.toStringAsFixed(1)}';
}
