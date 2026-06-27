import 'package:sistema_andreas/models/order_summary_group.dart';
import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_order_group.dart';
import 'package:sistema_andreas/utils/custom_ingredient_pricing.dart';
import 'package:sistema_andreas/utils/pastas_data.dart';
import 'package:sistema_andreas/utils/pizza_order_summary.dart';

List<OrderSummaryGroup> buildOrderSummaryGroups({
  required Map<String, int> pizzaQuantities,
  required Map<String, Map<int, PizzaFlavorSelection>> pizzaCustomizations,
  required Map<String, int> pastaQuantities,
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
        summaryLabel: quantity > 1
            ? '${quantity}x ${pasta.name}'
            : pasta.name,
      ),
    );
  }

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

double calculateOrderGrandTotal({
  required Map<String, int> pizzaQuantities,
  required Map<String, Map<int, PizzaFlavorSelection>> pizzaCustomizations,
  required Map<String, int> pastaQuantities,
}) {
  return calculateOrderBaseTotal(pizzaQuantities) +
      calculateOrderExtraTotal(
        quantities: pizzaQuantities,
        customizations: pizzaCustomizations,
      ) +
      calculatePastaOrderTotal(pastaQuantities);
}

int calculateTotalItems({
  required Map<String, int> pizzaQuantities,
  required Map<String, int> pastaQuantities,
}) {
  final pizzaTotal =
      pizzaQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  final pastaTotal =
      pastaQuantities.values.fold(0, (sum, quantity) => sum + quantity);
  return pizzaTotal + pastaTotal;
}
