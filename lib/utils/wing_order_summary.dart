import 'package:sistema_andreas/models/order_summary_group.dart';
import 'package:sistema_andreas/models/wing_batch.dart';
import 'package:sistema_andreas/utils/wing_flavors_data.dart';

String wingFlavorSummaryLabel({
  required int wingCount,
  required String flavorName,
}) {
  return '$wingCount alitas de $flavorName';
}

List<OrderSummaryGroup> buildWingSummaryGroups({
  required int wingCount,
  required Map<int, WingBatchSelection> batches,
}) {
  if (wingCount == 0) return [];

  final batchTotal = wingCount ~/ 10;
  final groups = <OrderSummaryGroup>[];
  final configuredByFlavor = <String, int>{};
  var unconfiguredBatches = 0;

  for (var index = 1; index <= batchTotal; index++) {
    final selection = batches[index];
    if (selection?.isComplete ?? false) {
      configuredByFlavor[selection!.flavorId] =
          (configuredByFlavor[selection.flavorId] ?? 0) + 1;
    } else {
      unconfiguredBatches++;
    }
  }

  if (unconfiguredBatches > 0) {
    final unconfiguredWings = unconfiguredBatches * 10;
    groups.add(
      OrderSummaryGroup(
        quantity: unconfiguredWings,
        summaryLabel: '$unconfiguredWings alitas sin seleccionar',
        isConfigured: false,
      ),
    );
  }

  for (final flavor in WingFlavorsData.flavors) {
    final batchQuantity = configuredByFlavor[flavor.id];
    if (batchQuantity == null || batchQuantity == 0) continue;

    final flavorWingCount = batchQuantity * 10;
    groups.add(
      OrderSummaryGroup(
        quantity: flavorWingCount,
        summaryLabel: wingFlavorSummaryLabel(
          wingCount: flavorWingCount,
          flavorName: flavor.name,
        ),
      ),
    );
  }

  return groups;
}
