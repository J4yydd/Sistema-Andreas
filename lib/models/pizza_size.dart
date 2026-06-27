class PizzaSize {
  const PizzaSize({
    required this.id,
    required this.name,
    required this.unitPrice,
    this.promoPairPrice,
    this.extraIngredientPrice,
    this.cheeseCrustPrice,
  });

  final String id;
  final String name;
  final double unitPrice;

  /// Precio total cuando se piden 2 (promoción). Null = sin promoción.
  final double? promoPairPrice;

  /// Cargo extra cuando una pizza personalizada lleva más de 3 ingredientes.
  final double? extraIngredientPrice;

  /// Cargo extra por orilla de queso. Null = no disponible para este tamaño.
  final double? cheeseCrustPrice;

  bool get hasPromo => promoPairPrice != null;
  bool get supportsCheeseCrust => cheeseCrustPrice != null;
}
