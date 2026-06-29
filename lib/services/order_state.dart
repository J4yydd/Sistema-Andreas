import 'package:flutter/foundation.dart';
import 'package:sistema_andreas/models/order_summary_group.dart';
import 'package:sistema_andreas/models/pasta_item.dart';
import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_size.dart';
import 'package:sistema_andreas/models/wing_batch.dart';
import 'package:sistema_andreas/utils/order_summary.dart';
import 'package:sistema_andreas/utils/wings_pricing.dart';

class OrderState extends ChangeNotifier {
  final Map<String, int> _quantities = {};
  final Map<String, Map<int, PizzaFlavorSelection>> _customizations = {};
  final Map<String, int> _pastaQuantities = {};
  final Map<String, String> _pastaNotes = {};
  int _wingCount = 0;
  Map<int, WingBatchSelection> _wingBatches = {};
  int _bonelessOrderCount = 0;
  Map<int, WingBatchSelection> _bonelessBatches = {};

  Map<String, int> get quantities => Map.unmodifiable(_quantities);

  Map<String, Map<int, PizzaFlavorSelection>> get customizations =>
      Map.unmodifiable(_customizations);

  Map<String, int> get pastaQuantities => Map.unmodifiable(_pastaQuantities);

  Map<String, String> get pastaNotes => Map.unmodifiable(_pastaNotes);

  int get wingCount => _wingCount;

  Map<int, WingBatchSelection> get wingBatches => Map.unmodifiable(_wingBatches);

  int get bonelessOrderCount => _bonelessOrderCount;

  Map<int, WingBatchSelection> get bonelessBatches =>
      Map.unmodifiable(_bonelessBatches);

  int get totalItems => calculateTotalItems(
        pizzaQuantities: _quantities,
        pastaQuantities: _pastaQuantities,
        wingCount: _wingCount,
        bonelessOrderCount: _bonelessOrderCount,
      );

  bool get hasItems => totalItems > 0;

  double get grandTotal => calculateOrderGrandTotal(
        pizzaQuantities: _quantities,
        pizzaCustomizations: _customizations,
        pastaQuantities: _pastaQuantities,
        wingCount: _wingCount,
        bonelessOrderCount: _bonelessOrderCount,
      );

  List<OrderSummaryGroup> get summaryGroups => buildOrderSummaryGroups(
        pizzaQuantities: _quantities,
        pizzaCustomizations: _customizations,
        pastaQuantities: _pastaQuantities,
        pastaNotes: _pastaNotes,
        wingCount: _wingCount,
        wingBatches: _wingBatches,
        bonelessOrderCount: _bonelessOrderCount,
        bonelessBatches: _bonelessBatches,
      );

  int quantityFor(String sizeId) => _quantities[sizeId] ?? 0;

  int pastaQuantityFor(String pastaId) => _pastaQuantities[pastaId] ?? 0;

  String pastaNotesFor(String pastaId) => _pastaNotes[pastaId] ?? '';

  int get configuredWingBatchCount {
    final batchTotal = wingBatchCount(_wingCount);
    return List.generate(
      batchTotal,
      (i) => _wingBatches[i + 1]?.isComplete ?? false,
    ).where((configured) => configured).length;
  }

  int get configuredBonelessOrderCount {
    return List.generate(
      _bonelessOrderCount,
      (i) => _bonelessBatches[i + 1]?.isComplete ?? false,
    ).where((configured) => configured).length;
  }

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
      _pastaNotes.remove(pasta.id);
    } else {
      _pastaQuantities[pasta.id] = next;
    }
    notifyListeners();
  }

  void setPastaNotes(String pastaId, String notes) {
    if (notes.isEmpty) {
      _pastaNotes.remove(pastaId);
    } else {
      _pastaNotes[pastaId] = notes;
    }
    notifyListeners();
  }

  void incrementWings() {
    _wingCount += 10;
    notifyListeners();
  }

  void decrementWings() {
    if (_wingCount <= 0) return;

    final batchToRemove = _wingCount ~/ 10;
    _wingCount -= 10;
    _wingBatches.remove(batchToRemove);
    if (_wingCount == 0) {
      _wingBatches = {};
    }
    notifyListeners();
  }

  void setWingBatches(Map<int, WingBatchSelection> value) {
    _wingBatches = value;
    notifyListeners();
  }

  void incrementBoneless() {
    _bonelessOrderCount++;
    notifyListeners();
  }

  void decrementBoneless() {
    if (_bonelessOrderCount <= 0) return;

    _bonelessBatches.remove(_bonelessOrderCount);
    _bonelessOrderCount--;
    if (_bonelessOrderCount == 0) {
      _bonelessBatches = {};
    }
    notifyListeners();
  }

  void setBonelessBatches(Map<int, WingBatchSelection> value) {
    _bonelessBatches = value;
    notifyListeners();
  }

  void setCustomizations(String sizeId, Map<int, PizzaFlavorSelection> value) {
    _customizations[sizeId] = value;
    notifyListeners();
  }
}
