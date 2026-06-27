import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/utils/pizza_order_summary.dart';

void main() {
  test('Agrupa todas las pizzas en orden global', () {
    final lines = buildPizzaOrderLines(
      quantities: {
        'familiar': 2,
        'personal': 1,
      },
      customizations: {
        'familiar': {
          1: const PizzaFlavorSelection(
            halves: [PizzaHalfSelection(flavorId: 'combinada')],
          ),
          2: const PizzaFlavorSelection(
            halves: [
              PizzaHalfSelection(flavorId: 'peperonni'),
              PizzaHalfSelection(flavorId: 'carnes_frias'),
            ],
          ),
        },
        'personal': {
          1: const PizzaFlavorSelection(
            halves: [PizzaHalfSelection(flavorId: 'andreas')],
          ),
        },
      },
    );

    expect(lines.length, 3);
    expect(lines[0].orderNumber, 1);
    expect(lines[0].size.name, 'Personal');
    expect(lines[0].flavorLabel, 'Andreas');
    expect(lines[1].orderNumber, 2);
    expect(lines[1].size.name, 'Familiar');
    expect(lines[1].flavorLabel, 'Combinada');
    expect(lines[2].orderNumber, 3);
    expect(lines[2].size.name, 'Familiar');
    expect(lines[2].flavorLabel, 'Peperonni / Carnes frías');
  });

  test('Agrupa pizzas idénticas en una sola línea', () {
    const peperonni = PizzaFlavorSelection(
      halves: [PizzaHalfSelection(flavorId: 'peperonni')],
    );

    final lines = buildPizzaOrderLines(
      quantities: {'familiar': 2},
      customizations: {
        'familiar': {
          1: peperonni,
          2: peperonni,
        },
      },
    );

    final groups = groupPizzaOrderLines(lines);

    expect(groups.length, 1);
    expect(groups.first.quantity, 2);
    expect(groups.first.summaryLabel, '2x familiares de Peperonni');
  });

  test('No agrupa pizzas diferentes aunque sean del mismo tamaño', () {
    final lines = buildPizzaOrderLines(
      quantities: {'familiar': 2},
      customizations: {
        'familiar': {
          1: const PizzaFlavorSelection(
            halves: [PizzaHalfSelection(flavorId: 'peperonni')],
          ),
          2: const PizzaFlavorSelection(
            halves: [PizzaHalfSelection(flavorId: 'combinada')],
          ),
        },
      },
    );

    final groups = groupPizzaOrderLines(lines);

    expect(groups.length, 2);
    expect(groups.every((group) => group.quantity == 1), isTrue);
  });
}
