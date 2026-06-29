import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/wing_batch.dart';
import 'package:sistema_andreas/screens/wing_batch_list_screen.dart';
import 'package:sistema_andreas/services/order_scope.dart';
import 'package:sistema_andreas/services/order_state.dart';
import 'package:sistema_andreas/widgets/app_scaffold.dart';
import 'package:sistema_andreas/widgets/wings_order_card.dart';

class WingsScreen extends StatelessWidget {
  const WingsScreen({super.key});

  Future<void> _openBatchList(
    BuildContext context,
    OrderState order,
  ) async {
    final wingCount = order.wingCount;
    if (wingCount == 0) return;

    final result = await Navigator.of(context).push<Map<int, WingBatchSelection>>(
      MaterialPageRoute(
        builder: (_) => WingBatchListScreen(
          wingCount: wingCount,
          initialBatches: Map.from(order.wingBatches),
        ),
      ),
    );

    if (result != null) {
      order.setWingBatches(result);
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
            title: 'Alitas',
            subtitle: 'Porciones de 10 · elige sabores',
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              WingsOrderCard(
                wingCount: order.wingCount,
                configuredBatchCount: order.configuredWingBatchCount,
                onDecrement: order.decrementWings,
                onIncrement: order.incrementWings,
                onCustomize: () => _openBatchList(context, order),
              ),
            ],
          ),
        );
      },
    );
  }
}
