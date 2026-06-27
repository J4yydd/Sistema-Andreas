import 'package:flutter/foundation.dart';
import 'package:sistema_andreas/models/order_summary_group.dart';
import 'package:sistema_andreas/models/pasta_item.dart';
import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_size.dart';
import 'package:sistema_andreas/utils/order_summary.dart';

class OrderState extends ChangeNotifier {
  final Map<String, int> _quantities = {};
  final Map<String, Map<int, PizzaFlavorSelection>> _customizations = {};
  final Map<String, int> _pastaQuantities = {};

  Map<String, int> get quantities => Map.unmodifiable(_quantities);

  Map<String, Map<int, PizzaFlavorSelection>> get customizations =>
      Map.unmodifiable(_customizations);

  Map<String, int> get pastaQuantities => Map.unmodifiable(_pastaQuantities);

  int get totalItems => calculateTotalItems(
        pizzaQuantities: _quantities,
        pastaQuantities: _pastaQuantities,
      );

  bool get hasItems => totalItems > 0;

  double get grandTotal => calculateOrderGrandTotal(
        pizzaQuantities: _quantities,
        pizzaCustomizations: _customizations,
        pastaQuantities: _pastaQuantities,
      );

  List<OrderSummaryGroup> get summaryGroups => buildOrderSummaryGroups(
        pizzaQuantities: _quantities,
        pizzaCustomizations: _customizations,
        pastaQuantities: _pastaQuantities,
      );

  int quantityFor(String sizeId) => _quantities[sizeId] ?? 0;

  int pastaQuantityFor(String pastaId) => _pastaQuantities[pastaId] ?? 0;

  Map<int, PizzaFlavorSelection> customizationsFor(String sizeId) {
    return _customizations[sizeId] ?? {};
  }

  int customizedCountFor(String sizeId) {
    final qty = quantityFor(sizeId);
    final items = customizationsFor(sizeId);
    return List.generate(qty, (i) => items[i + 1]?.isComplete ?? false)
        .where((configured) => configured)
        .length;
  }

  void increment(PizzaSize pizza) {
    _quantities[pizza.id] = quantityFor(pizza.id) + 1;
    notifyListeners();
  }

  void decrement(PizzaSize pizza) {
    final current = quantityFor(pizza.id);
    if (current <= 0) return;

    final next = current - 1;
    if (next == 0) {
      _quantities.remove(pizza.id);
      _customizations.remove(pizza.id);
    } else {
      _quantities[pizza.id] = next;
      _customizations[pizza.id]?.remove(current);
    }
    notifyListeners();
  }

  void incrementPasta(PastaItem pasta) {
    _pastaQuantities[pasta.id] = pastaQuantityFor(pasta.id) + 1;
    notifyListeners();
  }

  void decrementPasta(PastaItem pasta) {
    final current = pastaQuantityFor(pasta.id);
    if (current <= 0) return;

    final next = current - 1;
    if (next == 0) {
      _pastaQuantities.remove(pasta.id);
    } else {
      _pastaQuantities[pasta.id] = next;
    }
    notifyListeners();
  }

  void setCustomizations(String sizeId, Map<int, PizzaFlavorSelection> value) {
    _customizations[sizeId] = value;
    notifyListeners();
  }
}
