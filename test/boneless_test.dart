import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_andreas/models/wing_batch.dart';
import 'package:sistema_andreas/utils/boneless_data.dart';
import 'package:sistema_andreas/utils/boneless_order_summary.dart';
import 'package:sistema_andreas/utils/order_summary.dart';

void main() {
  test('Calcula total de boneless', () {
    expect(calculateBonelessOrderTotal(2), 240);
    expect(calculateBonelessOrderTotal(0), 0);
  });

  group('buildBonelessSummaryGroups', () {
    test('una orden con sabor', () {
      final groups = buildBonelessSummaryGroups(
        orderCount: 1,
        batches: {
          1: const WingBatchSelection(flavorId: 'bbq'),
        },
      );

      expect(groups.single.summaryLabel, 'Boneless de BBQ');
    });

    test('agrupa órdenes del mismo sabor', () {
      final groups = buildBonelessSummaryGroups(
        orderCount: 2,
        batches: {
          1: const WingBatchSelection(flavorId: 'bbq'),
          2: const WingBatchSelection(flavorId: 'bbq'),
        },
      );

      expect(groups.single.summaryLabel, '2 órdenes de boneless de BBQ');
    });

    test('separa órdenes de sabores distintos', () {
      final groups = buildBonelessSummaryGroups(
        orderCount: 2,
        batches: {
          1: const WingBatchSelection(flavorId: 'bbq'),
          2: const WingBatchSelection(flavorId: 'bufalo'),
        },
      );

      expect(groups.length, 2);
      expect(
        groups.map((g) => g.summaryLabel).toList(),
        containsAll([
          'Boneless de BBQ',
          'Boneless de Búfalo',
        ]),
      );
    });
  });

  test('260gr por orden y precio 120', () {
    expect(BonelessData.pricePerOrder, 120);
    expect(BonelessData.gramsPerOrder, 260);
  });
}
