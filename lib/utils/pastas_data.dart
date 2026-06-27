import 'package:sistema_andreas/models/pasta_item.dart';

class PastasData {
  PastasData._();

  static const List<PastaItem> items = [
    PastaItem(
      id: 'spaghetti_italiano',
      name: 'Spaghetti Italiano',
      unitPrice: 85,
    ),
    PastaItem(
      id: 'spaghetti_andreas',
      name: 'Spaghetti a la Andreas',
      unitPrice: 90,
    ),
    PastaItem(
      id: 'lasagna',
      name: 'Lasagna',
      unitPrice: 125,
    ),
  ];
}
