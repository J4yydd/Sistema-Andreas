import 'package:sistema_andreas/models/wing_batch.dart';

class WingFlavor {
  const WingFlavor({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

class WingFlavorsData {
  WingFlavorsData._();

  static const List<WingFlavor> flavors = [
    WingFlavor(id: 'bufalo', name: 'Búfalo'),
    WingFlavor(id: 'bbq', name: 'BBQ'),
    WingFlavor(id: 'andreas', name: 'Andreas'),
    WingFlavor(id: 'mango_habanero', name: 'Mango Habanero'),
  ];

  static WingFlavor? findById(String id) {
    for (final flavor in flavors) {
      if (flavor.id == id) return flavor;
    }
    return null;
  }

  static String selectionLabel(WingBatchSelection? selection) {
    if (selection == null || !selection.isComplete) {
      return 'Sin seleccionar';
    }

    return findById(selection.flavorId)?.name ?? selection.flavorId;
  }
}
