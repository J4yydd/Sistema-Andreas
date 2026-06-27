import 'package:flutter/material.dart';
import 'package:sistema_andreas/utils/price_formatter.dart';
import 'package:sistema_andreas/widgets/quantity_counter.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String name;
  final double unitPrice;
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  String get _priceLabel {
    if (quantity == 0) return formatPrice(unitPrice);
    return formatPrice(unitPrice * quantity);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = quantity > 0;

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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _priceLabel,
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
      ),
    );
  }
}
