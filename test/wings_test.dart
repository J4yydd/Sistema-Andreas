import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_andreas/models/wing_batch.dart';
import 'package:sistema_andreas/utils/wing_order_summary.dart';
import 'package:sistema_andreas/utils/wings_pricing.dart';

void main() {
  group('calculateWingsTotal', () {
    test('10 alitas = 130', () {
      expect(calculateWingsTotal(10), 130);
    });

    test('20 alitas = 220', () {
      expect(calculateWingsTotal(20), 220);
    });

    test('30 alitas = 350', () {
      expect(calculateWingsTotal(30), 350);
    });

    test('40 alitas = 440', () {
      expect(calculateWingsTotal(40), 440);
    });
  });

  group('buildWingSummaryGroups', () {
    test('agrupa porciones del mismo sabor', () {
      final groups = buildWingSummaryGroups(
        wingCount: 20,
        batches: {
          1: const WingBatchSelection(flavorId: 'bufalo'),
          2: const WingBatchSelection(flavorId: 'bufalo'),
        },
      );

      expect(groups.length, 1);
      expect(groups.single.summaryLabel, '20 alitas de Búfalo');
      expect(groups.single.quantity, 20);
    });

    test('separa porciones de sabores distintos', () {
      final groups = buildWingSummaryGroups(
        wingCount: 20,
        batches: {
          1: const WingBatchSelection(flavorId: 'bufalo'),
          2: const WingBatchSelection(flavorId: 'bbq'),
        },
      );

      expect(groups.length, 2);
      expect(groups[0].summaryLabel, '10 alitas de Búfalo');
      expect(groups[1].summaryLabel, '10 alitas de BBQ');
    });

    test('30 del mismo sabor muestra total', () {
      final groups = buildWingSummaryGroups(
        wingCount: 30,
        batches: {
          1: const WingBatchSelection(flavorId: 'bbq'),
          2: const WingBatchSelection(flavorId: 'bbq'),
          3: const WingBatchSelection(flavorId: 'bbq'),
        },
      );

      expect(groups.single.summaryLabel, '30 alitas de BBQ');
    });
  });
}
