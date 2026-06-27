import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_ingredient.dart';
import 'package:sistema_andreas/utils/custom_ingredients_data.dart';
import 'package:sistema_andreas/utils/pizza_extras_data.dart';

class PizzaFlavorsData {
  PizzaFlavorsData._();

  static const String personalizadoId = CustomIngredientsData.personalizadoId;

  static const List<PizzaFlavor> flavors = [
    PizzaFlavor(id: 'combinada', name: 'Combinada'),
    PizzaFlavor(id: 'peperonni', name: 'Peperonni'),
    PizzaFlavor(id: 'andreas', name: 'Andreas'),
    PizzaFlavor(id: 'arrachera', name: 'Arrachera'),
    PizzaFlavor(id: 'hawaiana', name: 'Hawaiana'),
    PizzaFlavor(id: 'carnes_frias', name: 'Carnes frías'),
    PizzaFlavor(id: 'italiana', name: 'Italiana'),
    PizzaFlavor(id: 'esp_atun', name: 'Esp. de atún'),
    PizzaFlavor(id: 'atun', name: 'Atún'),
    PizzaFlavor(id: 'salami', name: 'Salami'),
    PizzaFlavor(id: 'esp_peperonni', name: 'Esp. de peperonni'),
    PizzaFlavor(
      id: 'pollo',
      name: 'Pollo',
      subOptions: [
        PizzaFlavorSubOption(id: 'bbq', name: 'BBQ'),
        PizzaFlavorSubOption(id: 'bufalo', name: 'Bufalo'),
        PizzaFlavorSubOption(id: 'habanero', name: 'Habanero'),
      ],
    ),
    PizzaFlavor(id: 'mexicana', name: 'Mexicana'),
    PizzaFlavor(id: 'vegetariana', name: 'Vegetariana'),
    PizzaFlavor(id: 'especial_salami', name: 'Especial de salami'),
  ];

  static const PizzaFlavor personalizado = PizzaFlavor(
    id: personalizadoId,
    name: 'Personalizado',
    isCustomBuilder: true,
  );

  static PizzaFlavor? findById(String id) {
    if (id == personalizadoId) return personalizado;
    for (final flavor in flavors) {
      if (flavor.id == id) return flavor;
    }
    return null;
  }

  static String halfLabel(PizzaHalfSelection half) {
    if (half.flavorId == personalizadoId) {
      return _customHalfLabel(half.customData);
    }

    final flavor = findById(half.flavorId);
    if (flavor == null) return '';

    if (half.subOptionId != null) {
      for (final option in flavor.subOptions) {
        if (option.id == half.subOptionId) {
          return '${flavor.name} ${option.name}';
        }
      }
    }

    return flavor.name;
  }

  static String _customHalfLabel(PizzaCustomHalfData? data) {
    if (data == null || data.ingredientIds.isEmpty) {
      return '';
    }

    final names = CustomIngredientsData.ingredientNames(data.ingredientIds);
    return names.join(', ');
  }

  static String selectionLabel(PizzaFlavorSelection? selection) {
    if (selection == null || selection.halves.isEmpty) {
      return 'Sin seleccionar';
    }

    final String base;
    if (selection.halves.length == 1) {
      base = halfLabel(selection.halves.first);
    } else {
      base =
          '${halfLabel(selection.halves[0])} / ${halfLabel(selection.halves[1])}';
    }

    final parts = <String>[base];
    if (selection.cheeseCrust) {
      parts.add(PizzaExtrasData.cheeseCrustLabel);
    }

    final notes = selection.notes.trim();
    if (notes.isNotEmpty) {
      parts.add(notes);
    }

    return parts.join(' · ');
  }

  static bool isHalfSelected(
    List<PizzaHalfSelection> halves,
    PizzaHalfSelection half,
  ) {
    return halves.any((item) => _sameHalf(item, half));
  }

  static bool isFlavorIdSelected(
    List<PizzaHalfSelection> halves,
    String flavorId,
  ) {
    return halves.any((half) => half.flavorId == flavorId);
  }

  static bool _sameHalf(PizzaHalfSelection a, PizzaHalfSelection b) {
    if (a.flavorId != b.flavorId) return false;
    if (a.flavorId == personalizadoId) {
      return _sameCustomData(a.customData, b.customData);
    }
    return a.subOptionId == b.subOptionId;
  }

  static bool _sameCustomData(
    PizzaCustomHalfData? a,
    PizzaCustomHalfData? b,
  ) {
    if (a == null || b == null) return false;
    if (a.ingredientIds.length != b.ingredientIds.length) return false;
    for (var i = 0; i < a.ingredientIds.length; i++) {
      if (a.ingredientIds[i] != b.ingredientIds[i]) return false;
    }
    return true;
  }

  static int? indexOfPersonalizadoHalf(List<PizzaHalfSelection> halves) {
    for (var i = 0; i < halves.length; i++) {
      if (halves[i].flavorId == personalizadoId) return i;
    }
    return null;
  }
}
