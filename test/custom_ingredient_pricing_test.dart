import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_ingredient.dart';
import 'package:sistema_andreas/utils/custom_ingredient_pricing.dart';
import 'package:sistema_andreas/utils/pizzas_data.dart';

void main() {
  final familiar = PizzasData.sizes.firstWhere((s) => s.id == 'familiar');

  const customFour = PizzaHalfSelection(
    flavorId: 'personalizado',
    customData: PizzaCustomHalfData(
      ingredientIds: ['jamon', 'peperonni', 'salami', 'pina'],
    ),
  );

  group('calculateCustomHalfExtraCost', () {
    test('3 ingredientes o menos = sin extra', () {
      const half = PizzaHalfSelection(
        flavorId: 'personalizado',
        customData: PizzaCustomHalfData(
          ingredientIds: ['jamon', 'peperonni', 'salami'],
        ),
      );

      expect(
        calculateCustomHalfExtraCost(familiar, half, isSplitPizza: false),
        0,
      );
    });

    test('pizza completa con 4+ ingredientes = precio completo', () {
      expect(
        calculateCustomHalfExtraCost(familiar, customFour, isSplitPizza: false),
        21,
      );
    });

    test('media pizza con 4+ ingredientes = mitad del precio', () {
      expect(
        calculateCustomHalfExtraCost(familiar, customFour, isSplitPizza: true),
        10.5,
      );
    });
  });

  group('calculateSelectionExtraCost', () {
    test('mitad personalizada en pizza dividida', () {
      const selection = PizzaFlavorSelection(
        halves: [
          PizzaHalfSelection(flavorId: 'combinada'),
          customFour,
        ],
      );

      expect(calculateSelectionExtraCost(familiar, selection), 10.5);
    });

    test('pizza completa personalizada', () {
      const selection = PizzaFlavorSelection(halves: [customFour]);

      expect(calculateSelectionExtraCost(familiar, selection), 21);
    });

    test('dos mitades personalizadas con extra', () {
      const selection = PizzaFlavorSelection(
        halves: [customFour, customFour],
      );

      expect(calculateSelectionExtraCost(familiar, selection), 21);
    });

    test('orilla de queso en mediana', () {
      final mediana = PizzasData.sizes.firstWhere((s) => s.id == 'mediana');
      const selection = PizzaFlavorSelection(
        halves: [PizzaHalfSelection(flavorId: 'peperonni')],
        cheeseCrust: true,
      );

      expect(calculateSelectionExtraCost(mediana, selection), 50);
    });

    test('orilla de queso no disponible en personal', () {
      final personal = PizzasData.sizes.firstWhere((s) => s.id == 'personal');
      const selection = PizzaFlavorSelection(
        halves: [PizzaHalfSelection(flavorId: 'peperonni')],
        cheeseCrust: true,
      );

      expect(calculateSelectionExtraCost(personal, selection), 0);
    });
  });
}
