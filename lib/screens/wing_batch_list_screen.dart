import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/wing_batch.dart';
import 'package:sistema_andreas/screens/wing_flavor_screen.dart';
import 'package:sistema_andreas/utils/app_colors.dart';
import 'package:sistema_andreas/utils/wing_flavors_data.dart';

class WingBatchListScreen extends StatefulWidget {
  const WingBatchListScreen({
    super.key,
    required this.wingCount,
    required this.initialBatches,
  });

  final int wingCount;
  final Map<int, WingBatchSelection> initialBatches;

  @override
  State<WingBatchListScreen> createState() => _WingBatchListScreenState();
}

class _WingBatchListScreenState extends State<WingBatchListScreen> {
  late Map<int, WingBatchSelection> _batches;

  int get _batchCount => widget.wingCount ~/ 10;

  @override
  void initState() {
    super.initState();
    _batches = Map.from(widget.initialBatches);
  }

  Future<void> _openBatch(int index) async {
    final result = await Navigator.of(context).push<WingBatchSelection>(
      MaterialPageRoute(
        builder: (_) => WingFlavorScreen(
          batchIndex: index,
          initialSelection: _batches[index],
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
      _batchCount,
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
              '${widget.wingCount} alitas · $_batchCount porción${_batchCount == 1 ? '' : 'es'} de 10',
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
              itemCount: _batchCount,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final batchNumber = index + 1;
                final selection = _batches[batchNumber];
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
                    onTap: () => _openBatch(batchNumber),
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
                              '$batchNumber',
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
                                  '10 alitas #$batchNumber',
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
                      : 'Elige el sabor de cada porción',
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
