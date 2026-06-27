class PizzaIngredient {
  const PizzaIngredient({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

class PizzaCustomHalfData {
  const PizzaCustomHalfData({
    required this.ingredientIds,
  });

  final List<String> ingredientIds;
}
