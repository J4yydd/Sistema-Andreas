import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_size.dart';
import 'package:sistema_andreas/screens/pizza_customization_list_screen.dart';
import 'package:sistema_andreas/services/order_scope.dart';
import 'package:sistema_andreas/services/order_state.dart';
import 'package:sistema_andreas/utils/pizzas_data.dart';
import 'package:sistema_andreas/widgets/app_scaffold.dart';
import 'package:sistema_andreas/widgets/pizza_size_card.dart';

class PizzasScreen extends StatelessWidget {
  const PizzasScreen({super.key});

  Future<void> _openCustomization(
    BuildContext context,
    OrderState order,
    PizzaSize pizza,
  ) async {
    final quantity = order.quantityFor(pizza.id);
    if (quantity == 0) return;

    final result =
        await Navigator.of(context).push<Map<int, PizzaFlavorSelection>>(
      MaterialPageRoute(
        builder: (_) => PizzaCustomizationListScreen(
          pizzaSize: pizza,
          quantity: quantity,
          initialCustomizations: Map.from(order.customizationsFor(pizza.id)),
        ),
      ),
    );

    if (result != null) {
      order.setCustomizations(pizza.id, result);
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
            title: 'Pizzas',
            subtitle: 'Selecciona tamaño y cantidad',
          ),
          body: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: PizzasData.sizes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final pizza = PizzasData.sizes[index];
              final quantity = order.quantityFor(pizza.id);

              return PizzaSizeCard(
                pizza: pizza,
                quantity: quantity,
                customizedCount: order.customizedCountFor(pizza.id),
                onDecrement: () => order.decrement(pizza),
                onIncrement: () => order.increment(pizza),
                onCustomize: () => _openCustomization(context, order, pizza),
              );
            },
          ),
        );
      },
    );
  }
}
