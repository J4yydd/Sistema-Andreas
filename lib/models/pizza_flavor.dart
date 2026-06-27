import 'package:sistema_andreas/models/pizza_ingredient.dart';

class PizzaFlavor {
  const PizzaFlavor({
    required this.id,
    required this.name,
    this.subOptions = const [],
    this.isCustomBuilder = false,
  });

  final String id;
  final String name;
  final List<PizzaFlavorSubOption> subOptions;
  final bool isCustomBuilder;

  bool get requiresSubOption => subOptions.isNotEmpty;
}

class PizzaFlavorSubOption {
  const PizzaFlavorSubOption({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

class PizzaHalfSelection {
  const PizzaHalfSelection({
    required this.flavorId,
    this.subOptionId,
    this.customData,
  });

  final String flavorId;
  final String? subOptionId;
  final PizzaCustomHalfData? customData;
}

class PizzaFlavorSelection {
  const PizzaFlavorSelection({
    required this.halves,
    this.notes = '',
    this.cheeseCrust = false,
  });

  final List<PizzaHalfSelection> halves;
  final String notes;
  final bool cheeseCrust;

  bool get isComplete {
    if (halves.isEmpty) return false;
    for (final half in halves) {
      if (!_isHalfComplete(half)) return false;
    }
    return true;
  }

  static bool _isHalfComplete(PizzaHalfSelection half) {
    if (half.flavorId.isEmpty) return false;
    if (half.flavorId == 'personalizado') {
      return half.customData != null &&
          half.customData!.ingredientIds.isNotEmpty;
    }
    return true;
  }
}
