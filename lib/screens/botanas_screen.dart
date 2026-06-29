import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/wing_batch.dart';
import 'package:sistema_andreas/screens/boneless_batch_list_screen.dart';
import 'package:sistema_andreas/services/order_scope.dart';
import 'package:sistema_andreas/services/order_state.dart';
import 'package:sistema_andreas/widgets/app_scaffold.dart';
import 'package:sistema_andreas/widgets/boneless_order_card.dart';

class BotanasScreen extends StatelessWidget {
  const BotanasScreen({super.key});

  Future<void> _openBatchList(
    BuildContext context,
    OrderState order,
  ) async {
    final orderCount = order.bonelessOrderCount;
    if (orderCount == 0) return;

    final result = await Navigator.of(context).push<Map<int, WingBatchSelection>>(
      MaterialPageRoute(
        builder: (_) => BonelessBatchListScreen(
          orderCount: orderCount,
          initialBatches: Map.from(order.bonelessBatches),
        ),
      ),
    );

    if (result != null) {
      order.setBonelessBatches(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = OrderScope.of(context);

    return ListenableBuilder(
      listenable: order,
      builder: (context, _) {
        return AppScaffold(
          appBar: buildAppBar(
            context: context,
            title: 'Botanas',
            subtitle: 'Boneless 260gr · elige sabores',
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              BonelessOrderCard(
                orderCount: order.bonelessOrderCount,
                configuredOrderCount: order.configuredBonelessOrderCount,
                onDecrement: order.decrementBoneless,
                onIncrement: order.incrementBoneless,
                onCustomize: () => _openBatchList(context, order),
              ),
            ],
          ),
        );
      },
    );
  }
}
