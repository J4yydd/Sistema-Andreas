import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/order_summary_group.dart';
import 'package:sistema_andreas/utils/price_formatter.dart';

class OrderSummaryContent extends StatelessWidget {
  const OrderSummaryContent({
    super.key,
    required this.groups,
    required this.totalItems,
    required this.grandTotal,
    this.scrollController,
    this.showHeader = true,
  });

  final List<OrderSummaryGroup> groups;
  final int totalItems;
  final double grandTotal;
  final ScrollController? scrollController;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (totalItems == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long_rounded,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'Aún no hay items en la orden',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHeader) ...[
          Text(
            'Resumen de la orden',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            itemCount: groups.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final group = groups[index];

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: group.isConfigured
                      ? colorScheme.primaryContainer
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: group.isConfigured
                        ? colorScheme.primary
                        : colorScheme.outline,
                    width: group.isConfigured ? 2 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: group.isConfigured
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      child: Text(
                        '${group.quantity}',
                        style: textTheme.labelMedium?.copyWith(
                          color: group.isConfigured
                              ? colorScheme.onPrimary
                              : colorScheme.surface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.summaryLabel,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (group.totalExtraCost > 0) ...[
                            const SizedBox(height: 2),
                            Text(
                              '+ ${formatPrice(group.totalExtraCost)} extras',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Divider(height: 1, color: colorScheme.outline),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: Text(
                '$totalItems producto${totalItems == 1 ? '' : 's'}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              formatPrice(grandTotal),
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
