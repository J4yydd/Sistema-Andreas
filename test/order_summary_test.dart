import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_andreas/utils/order_summary.dart';

void main() {
  test('Calcula total de pastas', () {
    expect(
      calculatePastaOrderTotal({
        'spaghetti_italiano': 2,
        'lasagna': 1,
      }),
      295,
    );
  });

  test('Incluye pastas en el resumen de la orden', () {
    final groups = buildOrderSummaryGroups(
      pizzaQuantities: {},
      pizzaCustomizations: {},
      pastaQuantities: {
        'spaghetti_italiano': 2,
        'spaghetti_andreas': 1,
      },
    );

    expect(groups.length, 2);
    expect(groups[0].summaryLabel, '2x Spaghetti Italiano');
    expect(groups[1].summaryLabel, 'Spaghetti a la Andreas');
  });

  test('Calcula total general con pizzas y pastas', () {
    expect(
      calculateOrderGrandTotal(
        pizzaQuantities: {'personal': 1},
        pizzaCustomizations: {},
        pastaQuantities: {'lasagna': 1},
      ),
      207,
    );
  });

  test('Cuenta items de pizzas y pastas', () {
    expect(
      calculateTotalItems(
        pizzaQuantities: {'personal': 2},
        pastaQuantities: {'lasagna': 1},
      ),
      3,
    );
  });
}
