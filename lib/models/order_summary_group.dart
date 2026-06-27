class OrderSummaryGroup {
  const OrderSummaryGroup({
    required this.quantity,
    required this.summaryLabel,
    this.extraCostPerUnit = 0,
    this.isConfigured = true,
  });

  final int quantity;
  final String summaryLabel;
  final double extraCostPerUnit;
  final bool isConfigured;

  double get totalExtraCost => extraCostPerUnit * quantity;
}
