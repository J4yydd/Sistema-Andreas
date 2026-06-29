import 'package:sistema_andreas/models/order_summary_group.dart';
import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_order_group.dart';
import 'package:sistema_andreas/models/wing_batch.dart';
import 'package:sistema_andreas/utils/boneless_data.dart';
import 'package:sistema_andreas/utils/boneless_order_summary.dart';
import 'package:sistema_andreas/utils/custom_ingredient_pricing.dart';
import 'package:sistema_andreas/utils/pasta_labels.dart';
import 'package:sistema_andreas/utils/pastas_data.dart';
import 'package:sistema_andreas/utils/pizza_order_summary.dart';
import 'package:sistema_andreas/utils/wing_order_summary.dart';
import 'package:sistema_andreas/utils/wings_pricing.dart';

List<OrderSummaryGroup> buildOrderSummaryGroups({
  required Map<String, int> pizzaQuantities,
  required Map<String, Map<int, PizzaFlavorSelection>> pizzaCustomizations,
  required Map<String, int> pastaQuantities,
  Map<String, String> pastaNotes = const {},
  int wingCount = 0,
  Map<int, WingBatchSelection> wingBatches = const {},
  int bonelessOrderCount = 0,
  Map<int, WingBatchSelection> bonelessBatches = const {},
}) {
  final groups = <OrderSummaryGroup>[];

  final pizzaLines = buildPizzaOrderLines(
    quantities: pizzaQuantities,
    customizations: pizzaCustomizations,
  );
  for (final group in groupPizzaOrderLines(pizzaLines)) {
    groups.add(_fromPizzaGroup(group));
  }

  for (final pasta in PastasData.items) {
    final quantity = pastaQuantities[pasta.id] ?? 0;
    if (quantity == 0) continue;

    groups.add(
      OrderSummaryGroup(
        quantity: quantity,
        summaryLabel: pastaSummaryLabel(
          name: pasta.name,
          quantity: quantity,
          notes: pastaNotes[pasta.id] ?? '',
        ),
      ),
    );
  }

  groups.addAll(
    buildWingSummaryGroups(
      wingCount: wingCount,
      batches: wingBatches,
    ),
  );

  groups.addAll(
    buildBonelessSummaryGroups(
      orderCount: bonelessOrderCount,
      batches: bonelessBatches,
    ),
  );

  return groups;
}

OrderSummaryGroup _fromPizzaGroup(PizzaOrderGroup group) {
  return OrderSummaryGroup(
    quantity: group.quantity,
    summaryLabel: group.summaryLabel,
    extraCostPerUnit: group.extraCostPerUnit,
    isConfigured: group.isConfigured,
  );
}

double calculatePastaOrderTotal(Map<String, int> pastaQuantities) {
  var total = 0.0;

  for (final pasta in PastasData.items) {
    final quantity = pastaQuantities[pasta.id] ?? 0;
    total += quantity * pasta.unitPrice;
  }

  return total;
}

double calculateBonelessOrderTotal(int bonelessOrderCount) {
  return bonelessOrderCount * BonelessData.pricePerOrder;
}

double calculateOrderGrandTotal({
  required Map<String, int> pizzaQuantities,
  required Map<String, Map<int, PizzaFlavorSelection>> pizzaCustomizations,
  required Map<String, int> pastaQuantities,
  int wingCount = 0,
  int bonelessOrderCount = 0,
}) {
  return calculateOrderBaseTotal(pizzaQuantities) +
      calculateOrderExtraTotal(
        quantities: pizzaQuantities,
        customizations: pizzaCustomizations,
      ) +
      calculatePastaOrderTotal(pastaQuantities) +
      calculateWingsTotal(wingCount) +
      calculateBonelessOrderTotal(bonelessOrderCount);
}

int calculateTotalItems({
  required Map<String, int> pizzaQuantities,
  required Map<String, int> pastaQuantities,
  int wingCount = 0,
  int bonelessOrderCount = 0,
}) {
  final pizzaTotal =
      pizzaQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  final pastaTotal =
      pastaQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  final wingBatchTotal = wingBatchCount(wingCount);
  return pizzaTotal + pastaTotal + wingBatchTotal + bonelessOrderCount;
}
