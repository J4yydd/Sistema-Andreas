import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_order_group.dart';
import 'package:sistema_andreas/models/pizza_order_line.dart';
import 'package:sistema_andreas/utils/pizzas_data.dart';

List<PizzaOrderLine> buildPizzaOrderLines({
  required Map<String, int> quantities,
  required Map<String, Map<int, PizzaFlavorSelection>> customizations,
}) {
  final lines = <PizzaOrderLine>[];
  var orderNumber = 0;

  for (final size in PizzasData.sizes) {
    final quantity = quantities[size.id] ?? 0;
    if (quantity == 0) continue;

    final sizeCustomizations = customizations[size.id] ?? {};
    for (var index = 1; index <= quantity; index++) {
      orderNumber++;
      lines.add(
        PizzaOrderLine(
          orderNumber: orderNumber,
          size: size,
          selection: sizeCustomizations[index],
        ),
      );
    }
  }

  return lines;
}

List<PizzaOrderGroup> groupPizzaOrderLines(List<PizzaOrderLine> lines) {
  final groups = <String, PizzaOrderGroup>{};
  final order = <String>[];

  for (final line in lines) {
    final key = pizzaOrderGroupKey(line.size, line.selection);

    if (groups.containsKey(key)) {
      final current = groups[key]!;
      groups[key] = PizzaOrderGroup(
        quantity: current.quantity + 1,
        size: current.size,
        selection: current.selection,
      );
    } else {
      order.add(key);
      groups[key] = PizzaOrderGroup(
        quantity: 1,
        size: line.size,
        selection: line.selection,
      );
    }
  }

  return order.map((key) => groups[key]!).toList();
}
