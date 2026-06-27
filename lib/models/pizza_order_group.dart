import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_size.dart';
import 'package:sistema_andreas/utils/custom_ingredient_pricing.dart';
import 'package:sistema_andreas/utils/pizza_flavors_data.dart';
import 'package:sistema_andreas/utils/pizza_size_labels.dart';

class PizzaOrderGroup {
  const PizzaOrderGroup({
    required this.quantity,
    required this.size,
    this.selection,
  });

  final int quantity;
  final PizzaSize size;
  final PizzaFlavorSelection? selection;

  bool get isConfigured => selection?.isComplete ?? false;

  String get flavorLabel => PizzaFlavorsData.selectionLabel(selection);

  String get summaryLabel {
    if (!isConfigured) {
      if (quantity > 1) {
        return '${quantity}x ${PizzaSizeLabels.plural(size)} sin seleccionar';
      }
      return '${PizzaSizeLabels.singular(size)} sin seleccionar';
    }

    if (quantity > 1) {
      return '${quantity}x ${PizzaSizeLabels.plural(size)} de $flavorLabel';
    }

    return '${PizzaSizeLabels.singular(size)} de $flavorLabel';
  }

  double get extraCostPerUnit =>
      calculateSelectionExtraCost(size, selection);

  double get totalExtraCost => extraCostPerUnit * quantity;
}

String pizzaSelectionKey(PizzaFlavorSelection? selection) {
  if (selection == null) return 'none';
  final halvesKey = selection.halves.map(_halfKey).join('||');
  return '$halvesKey||${selection.notes.trim()}||${selection.cheeseCrust}';
}

String _halfKey(PizzaHalfSelection half) {
  final custom = half.customData;
  final ingredients = custom?.ingredientIds.join(',') ?? '';
  return '${half.flavorId}:${half.subOptionId ?? ''}:$ingredients';
}

String pizzaOrderGroupKey(PizzaSize size, PizzaFlavorSelection? selection) {
  return '${size.id}|${pizzaSelectionKey(selection)}';
}
