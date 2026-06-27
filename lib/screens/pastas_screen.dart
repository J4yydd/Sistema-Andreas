import 'package:flutter/material.dart';
import 'package:sistema_andreas/services/order_scope.dart';
import 'package:sistema_andreas/utils/pastas_data.dart';
import 'package:sistema_andreas/widgets/app_scaffold.dart';
import 'package:sistema_andreas/widgets/menu_item_card.dart';

class PastasScreen extends StatelessWidget {
  const PastasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = OrderScope.of(context);

    return ListenableBuilder(
      listenable: order,
      builder: (context, _) {
        return AppScaffold(
          appBar: buildAppBar(
            context: context,
            title: 'Pastas',
            subtitle: 'Selecciona plato y cantidad',
          ),
          body: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: PastasData.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final pasta = PastasData.items[index];
              final quantity = order.pastaQuantityFor(pasta.id);

              return MenuItemCard(
                name: pasta.name,
                unitPrice: pasta.unitPrice,
                quantity: quantity,
                onDecrement: () => order.decrementPasta(pasta),
                onIncrement: () => order.incrementPasta(pasta),
              );
            },
          ),
        );
      },
    );
  }
}
