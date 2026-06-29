import 'package:flutter/material.dart';
import 'package:sistema_andreas/utils/boneless_data.dart';
import 'package:sistema_andreas/utils/price_formatter.dart';
import 'package:sistema_andreas/widgets/quantity_counter.dart';

class BonelessOrderCard extends StatelessWidget {
  const BonelessOrderCard({
    super.key,
    required this.orderCount,
    required this.configuredOrderCount,
    required this.onDecrement,
    required this.onIncrement,
    required this.onCustomize,
  });

  final int orderCount;
  final int configuredOrderCount;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onCustomize;

  bool get _allConfigured =>
      orderCount > 0 && configuredOrderCount >= orderCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = orderCount > 0;
    final totalPrice = orderCount * BonelessData.pricePerOrder;

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
                        BonelessData.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${BonelessData.gramsPerOrder}gr por orden',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formatPrice(totalPrice),
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (orderCount == 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          '1 orden · ${formatPrice(BonelessData.pricePerOrder)}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                QuantityCounter(
                  quantity: orderCount,
                  onDecrement: onDecrement,
                  onIncrement: onIncrement,
                ),
              ],
            ),
            if (orderCount > 0) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onCustomize,
                icon: Icon(
                  _allConfigured
                      ? Icons.check_circle_rounded
                      : Icons.tune_rounded,
                  size: 20,
                ),
                label: Text(
                  _allConfigured
                      ? 'Sabores listos ($configuredOrderCount/$orderCount)'
                      : 'Elegir sabores ($configuredOrderCount/$orderCount)',
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
