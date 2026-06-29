import 'package:flutter/material.dart';
import 'package:sistema_andreas/utils/price_formatter.dart';
import 'package:sistema_andreas/utils/wings_pricing.dart';
import 'package:sistema_andreas/widgets/quantity_counter.dart';

class WingsOrderCard extends StatelessWidget {
  const WingsOrderCard({
    super.key,
    required this.wingCount,
    required this.configuredBatchCount,
    required this.onDecrement,
    required this.onIncrement,
    required this.onCustomize,
  });

  final int wingCount;
  final int configuredBatchCount;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onCustomize;

  int get _batchCount => wingBatchCount(wingCount);

  bool get _allConfigured =>
      wingCount > 0 && configuredBatchCount >= _batchCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = wingCount > 0;

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
                        'Alitas',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Porciones de 10',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formatPrice(calculateWingsTotal(wingCount)),
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (wingCount == 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          '10 · ${formatPrice(wingsBatchPrice)}  ·  20 · ${formatPrice(wingsDoubleBatchPrice)}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                QuantityCounter(
                  quantity: wingCount,
                  step: 10,
                  onDecrement: onDecrement,
                  onIncrement: onIncrement,
                ),
              ],
            ),
            if (wingCount > 0) ...[
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
                      ? 'Sabores listos ($configuredBatchCount/$_batchCount)'
                      : 'Elegir sabores ($configuredBatchCount/$_batchCount)',
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
