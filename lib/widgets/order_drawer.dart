import 'package:flutter/material.dart';
import 'package:sistema_andreas/services/order_scope.dart';
import 'package:sistema_andreas/widgets/order_summary_content.dart';

class OrderDrawer extends StatelessWidget {
  const OrderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final order = OrderScope.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: order,
      builder: (context, _) {
        return Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tu orden',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (order.hasItems)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${order.totalItems}',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: OrderSummaryContent(
                      groups: order.summaryGroups,
                      totalItems: order.totalItems,
                      grandTotal: order.grandTotal,
                      showHeader: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
