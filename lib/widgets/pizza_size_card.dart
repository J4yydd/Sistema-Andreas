import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/pizza_size.dart';
import 'package:sistema_andreas/utils/pizza_pricing.dart';
import 'package:sistema_andreas/utils/price_formatter.dart';
import 'package:sistema_andreas/widgets/quantity_counter.dart';

class PizzaSizeCard extends StatelessWidget {
  const PizzaSizeCard({
    super.key,
    required this.pizza,
    required this.quantity,
    required this.customizedCount,
    required this.onDecrement,
    required this.onIncrement,
    required this.onCustomize,
  });

  final PizzaSize pizza;
  final int quantity;
  final int customizedCount;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onCustomize;

  String _priceLabel() {
    if (quantity == 0) {
      return formatPrice(pizza.unitPrice);
    }

    return formatPrice(
      calculatePizzaTotal(
        quantity,
        pizza.unitPrice,
        promoPairPrice: pizza.promoPairPrice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = quantity > 0;
    final allCustomized = quantity > 0 && customizedCount >= quantity;

    return Card(
      color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pizza.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _priceLabel(),
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                QuantityCounter(
                  quantity: quantity,
                  onDecrement: onDecrement,
                  onIncrement: onIncrement,
                ),
              ],
            ),
            if (quantity > 0) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onCustomize,
                icon: Icon(
                  allCustomized
                      ? Icons.check_circle_rounded
                      : Icons.tune_rounded,
                  size: 20,
                ),
                label: Text(
                  allCustomized
                      ? 'Personalizadas ($customizedCount/$quantity)'
                      : 'Personalizar ($customizedCount/$quantity)',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
