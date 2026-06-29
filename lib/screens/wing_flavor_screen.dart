import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/wing_batch.dart';
import 'package:sistema_andreas/utils/wing_flavors_data.dart';
import 'package:sistema_andreas/widgets/flavor_option_chip.dart';

class WingFlavorScreen extends StatefulWidget {
  const WingFlavorScreen({
    super.key,
    required this.batchIndex,
    this.initialSelection,
    this.appBarTitle,
    this.portionLabel,
    this.selectionHint,
  });

  final int batchIndex;
  final WingBatchSelection? initialSelection;
  final String? appBarTitle;
  final String? portionLabel;
  final String? selectionHint;

  @override
  State<WingFlavorScreen> createState() => _WingFlavorScreenState();
}

class _WingFlavorScreenState extends State<WingFlavorScreen> {
  String? _selectedFlavorId;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialSelection;
    if (initial != null && initial.isComplete) {
      _selectedFlavorId = initial.flavorId;
    }
  }

  bool get _canConfirm =>
      _selectedFlavorId != null && _selectedFlavorId!.isNotEmpty;

  void _confirmSelection() {
    if (!_canConfirm) return;
    Navigator.of(context).pop(
      WingBatchSelection(flavorId: _selectedFlavorId!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final currentLabel = _selectedFlavorId == null
        ? 'Selecciona el sabor'
        : WingFlavorsData.findById(_selectedFlavorId!)?.name ?? '';

    final appBarTitle =
        widget.appBarTitle ?? '10 alitas #${widget.batchIndex}';
    final portionLabel =
        widget.portionLabel ?? 'Porción de 10 alitas';
    final selectionHint =
        widget.selectionHint ?? 'Elige 1 sabor para esta porción';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        toolbarHeight: 56,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              border: Border(
                bottom: BorderSide(color: colorScheme.outline),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  portionLabel,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentLabel,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Sabores',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  selectionHint,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final flavor in WingFlavorsData.flavors)
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 42) / 2,
                        child: FlavorOptionChip(
                          label: flavor.name,
                          selected: _selectedFlavorId == flavor.id,
                          onTap: () => setState(
                            () => _selectedFlavorId = flavor.id,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SafeArea(
              top: false,
              child: FilledButton(
                onPressed: _canConfirm ? _confirmSelection : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Confirmar sabor',
                  style: TextStyle(
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
