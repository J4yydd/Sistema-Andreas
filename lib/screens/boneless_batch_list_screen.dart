import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/wing_batch.dart';
import 'package:sistema_andreas/screens/wing_flavor_screen.dart';
import 'package:sistema_andreas/utils/app_colors.dart';
import 'package:sistema_andreas/utils/boneless_data.dart';
import 'package:sistema_andreas/utils/wing_flavors_data.dart';

class BonelessBatchListScreen extends StatefulWidget {
  const BonelessBatchListScreen({
    super.key,
    required this.orderCount,
    required this.initialBatches,
  });

  final int orderCount;
  final Map<int, WingBatchSelection> initialBatches;

  @override
  State<BonelessBatchListScreen> createState() =>
      _BonelessBatchListScreenState();
}

class _BonelessBatchListScreenState extends State<BonelessBatchListScreen> {
  late Map<int, WingBatchSelection> _batches;

  @override
  void initState() {
    super.initState();
    _batches = Map.from(widget.initialBatches);
  }

  Future<void> _openOrder(int index) async {
    final result = await Navigator.of(context).push<WingBatchSelection>(
      MaterialPageRoute(
        builder: (_) => WingFlavorScreen(
          batchIndex: index,
          initialSelection: _batches[index],
          appBarTitle: 'Orden #$index',
          portionLabel: '${BonelessData.gramsPerOrder}gr boneless',
          selectionHint: 'Elige 1 sabor para esta orden',
        ),
      ),
    );

    if (result != null) {
      setState(() => _batches[index] = result);
    }
  }

  void _saveAndClose() {
    Navigator.of(context).pop(_batches);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final allConfigured = List.generate(
      widget.orderCount,
      (i) => _batches[i + 1]?.isComplete ?? false,
    ).every((configured) => configured);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sabores',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textOnDark,
              ),
            ),
            Text(
              '${widget.orderCount} orden${widget.orderCount == 1 ? '' : 'es'} · ${BonelessData.gramsPerOrder}gr c/u',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        toolbarHeight: 72,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: widget.orderCount,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final orderNumber = index + 1;
                final selection = _batches[orderNumber];
                final label = WingFlavorsData.selectionLabel(selection);
                final isConfigured = selection?.isComplete ?? false;

                return Card(
                  color: isConfigured
                      ? colorScheme.primaryContainer
                      : colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: isConfigured
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => _openOrder(orderNumber),
                    borderRadius: BorderRadius.circular(18),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: isConfigured
                                ? colorScheme.primary
                                : colorScheme.surfaceContainerHigh,
                            child: Text(
                              '$orderNumber',
                              style: textTheme.titleMedium?.copyWith(
                                color: isConfigured
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Orden #$orderNumber · ${BonelessData.gramsPerOrder}gr',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  label,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: isConfigured
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                    fontWeight: isConfigured
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SafeArea(
              top: false,
              child: FilledButton(
                onPressed: allConfigured ? _saveAndClose : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  allConfigured
                      ? 'Listo'
                      : 'Elige el sabor de cada orden',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
