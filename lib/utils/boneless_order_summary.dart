import 'package:sistema_andreas/models/order_summary_group.dart';
import 'package:sistema_andreas/models/wing_batch.dart';
import 'package:sistema_andreas/utils/wing_flavors_data.dart';

String bonelessFlavorSummaryLabel({
  required int orderCount,
  required String flavorName,
}) {
  if (orderCount == 1) {
    return 'Boneless de $flavorName';
  }
  return '$orderCount órdenes de boneless de $flavorName';
}

List<OrderSummaryGroup> buildBonelessSummaryGroups({
  required int orderCount,
  required Map<int, WingBatchSelection> batches,
}) {
  if (orderCount == 0) return [];

  final groups = <OrderSummaryGroup>[];
  final configuredByFlavor = <String, int>{};
  var unconfiguredOrders = 0;

  for (var index = 1; index <= orderCount; index++) {
    final selection = batches[index];
    if (selection?.isComplete ?? false) {
      configuredByFlavor[selection!.flavorId] =
          (configuredByFlavor[selection.flavorId] ?? 0) + 1;
    } else {
      unconfiguredOrders++;
    }
  }

  if (unconfiguredOrders > 0) {
    final label = unconfiguredOrders == 1
        ? 'Boneless sin seleccionar'
        : '$unconfiguredOrders órdenes de boneless sin seleccionar';
    groups.add(
      OrderSummaryGroup(
        quantity: unconfiguredOrders,
        summaryLabel: label,
        isConfigured: false,
      ),
    );
  }

  for (final flavor in WingFlavorsData.flavors) {
    final flavorOrderCount = configuredByFlavor[flavor.id];
    if (flavorOrderCount == null || flavorOrderCount == 0) continue;

    groups.add(
      OrderSummaryGroup(
        quantity: flavorOrderCount,
        summaryLabel: bonelessFlavorSummaryLabel(
          orderCount: flavorOrderCount,
          flavorName: flavor.name,
        ),
      ),
    );
  }

  return groups;
}
