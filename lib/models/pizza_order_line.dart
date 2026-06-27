import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_size.dart';
import 'package:sistema_andreas/utils/custom_ingredient_pricing.dart';
import 'package:sistema_andreas/utils/pizza_flavors_data.dart';

class PizzaOrderLine {
  const PizzaOrderLine({
    required this.orderNumber,
    required this.size,
    this.selection,
  });

  final int orderNumber;
  final PizzaSize size;
  final PizzaFlavorSelection? selection;

  bool get isConfigured => selection?.isComplete ?? false;

  String get flavorLabel => PizzaFlavorsData.selectionLabel(selection);

  double get extraCost =>
      calculateSelectionExtraCost(size, selection);
}
