import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_ingredient.dart';
import 'package:sistema_andreas/utils/pizza_flavors_data.dart';

void main() {
  group('PizzaFlavorsData.selectionLabel', () {
    test('sin selección', () {
      expect(PizzaFlavorsData.selectionLabel(null), 'Sin seleccionar');
    });

    test('un solo sabor', () {
      const selection = PizzaFlavorSelection(
        halves: [PizzaHalfSelection(flavorId: 'peperonni')],
      );
      expect(PizzaFlavorsData.selectionLabel(selection), 'Peperonni');
    });

    test('dos mitades', () {
      const selection = PizzaFlavorSelection(
        halves: [
          PizzaHalfSelection(flavorId: 'peperonni'),
          PizzaHalfSelection(flavorId: 'combinada'),
        ],
      );
      expect(
        PizzaFlavorsData.selectionLabel(selection),
        'Peperonni / Combinada',
      );
    });

    test('pollo con subopción', () {
      const selection = PizzaFlavorSelection(
        halves: [
          PizzaHalfSelection(flavorId: 'pollo', subOptionId: 'bbq'),
        ],
      );
      expect(PizzaFlavorsData.selectionLabel(selection), 'Pollo BBQ');
    });

    test('mitades con pollo', () {
      const selection = PizzaFlavorSelection(
        halves: [
          PizzaHalfSelection(flavorId: 'peperonni'),
          PizzaHalfSelection(flavorId: 'pollo', subOptionId: 'habanero'),
        ],
      );
      expect(
        PizzaFlavorsData.selectionLabel(selection),
        'Peperonni / Pollo Habanero',
      );
    });

    test('personalizado con ingredientes', () {
      const selection = PizzaFlavorSelection(
        halves: [
          PizzaHalfSelection(
            flavorId: 'personalizado',
            customData: PizzaCustomHalfData(
              ingredientIds: ['jamon', 'peperonni'],
            ),
          ),
        ],
      );
      expect(
        PizzaFlavorsData.selectionLabel(selection),
        'Jamón, Peperonni',
      );
    });

    test('personalizado con notas en la pizza', () {
      const selection = PizzaFlavorSelection(
        halves: [
          PizzaHalfSelection(
            flavorId: 'peperonni',
          ),
        ],
        notes: 'No muy dorada',
      );
      expect(
        PizzaFlavorsData.selectionLabel(selection),
        'Peperonni · No muy dorada',
      );
    });

    test('con orilla de queso', () {
      const selection = PizzaFlavorSelection(
        halves: [PizzaHalfSelection(flavorId: 'peperonni')],
        cheeseCrust: true,
      );
      expect(
        PizzaFlavorsData.selectionLabel(selection),
        'Peperonni · Orilla de queso',
      );
    });

    test('con orilla de queso y notas', () {
      const selection = PizzaFlavorSelection(
        halves: [PizzaHalfSelection(flavorId: 'peperonni')],
        cheeseCrust: true,
        notes: 'No muy dorada',
      );
      expect(
        PizzaFlavorsData.selectionLabel(selection),
        'Peperonni · Orilla de queso · No muy dorada',
      );
    });
  });
}
