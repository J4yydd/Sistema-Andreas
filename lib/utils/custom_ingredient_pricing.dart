import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_order_line.dart';
import 'package:sistema_andreas/models/pizza_size.dart';
import 'package:sistema_andreas/utils/custom_ingredients_data.dart';
import 'package:sistema_andreas/utils/pizza_pricing.dart';
import 'package:sistema_andreas/utils/pizzas_data.dart';

const _maxFreeIngredients = 3;

double calculateCheeseCrustExtraCost(PizzaSize size, bool cheeseCrust) {
  if (!cheeseCrust) return 0;
  return size.cheeseCrustPrice ?? 0;
}

/// Calcula el extra de una mitad personalizada con más de 3 ingredientes.
double calculateCustomHalfExtraCost(
  PizzaSize size,
  PizzaHalfSelection half, {
  required bool isSplitPizza,
}) {
  if (half.flavorId != CustomIngredientsData.personalizadoId) return 0;

  final data = half.customData;
  if (data == null || data.ingredientIds.length <= _maxFreeIngredients) {
    return 0;
  }

  final fullExtra = size.extraIngredientPrice ?? 0;
  if (fullExtra == 0) return 0;

  return isSplitPizza ? fullExtra / 2 : fullExtra;
}

/// Extra total de una pizza según su personalización final.
double calculateSelectionExtraCost(
  PizzaSize size,
  PizzaFlavorSelection? selection,
) {
  if (selection == null) return 0;

  final isSplitPizza = selection.halves.length == 2;
  var total = 0.0;

  for (final half in selection.halves) {
    total += calculateCustomHalfExtraCost(
      size,
      half,
      isSplitPizza: isSplitPizza,
    );
  }

  total += calculateCheeseCrustExtraCost(size, selection.cheeseCrust);

  return total;
}

double calculateOrderBaseTotal(Map<String, int> quantities) {
  var total = 0.0;
  for (final pizza in PizzasData.sizes) {
    final qty = quantities[pizza.id] ?? 0;
    total += calculatePizzaTotal(
      qty,
      pizza.unitPrice,
      promoPairPrice: pizza.promoPairPrice,
    );
  }
  return total;
}

double calculateOrderExtraTotal({
  required Map<String, int> quantities,
  required Map<String, Map<int, PizzaFlavorSelection>> customizations,
}) {
  var total = 0.0;

  for (final size in PizzasData.sizes) {
    final qty = quantities[size.id] ?? 0;
    if (qty == 0) continue;

    final sizeCustomizations = customizations[size.id] ?? {};
    for (var index = 1; index <= qty; index++) {
      total += calculateSelectionExtraCost(
        size,
        sizeCustomizations[index],
      );
    }
  }

  return total;
}

double calculateOrderExtraTotalFromLines(List<PizzaOrderLine> lines) {
  return lines.fold(0.0, (sum, line) => sum + line.extraCost);
}
