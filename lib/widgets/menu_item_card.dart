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
    this.notes = '',
    this.onNotesChanged,
  });

  final String name;
  final double unitPrice;
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final String notes;
  final ValueChanged<String>? onNotesChanged;

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
            if (quantity > 0 && onNotesChanged != null) ...[
              const SizedBox(height: 14),
              Text(
                'Nota adicional',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              MenuItemNoteField(
                notes: notes,
                onChanged: onNotesChanged!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MenuItemNoteField extends StatefulWidget {
  const MenuItemNoteField({
    super.key,
    required this.notes,
    required this.onChanged,
  });

  final String notes;
  final ValueChanged<String> onChanged;

  @override
  State<MenuItemNoteField> createState() => _MenuItemNoteFieldState();
}

class _MenuItemNoteFieldState extends State<MenuItemNoteField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      maxLines: 2,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        hintText: 'Ej: sin queso, extra picante...',
      ),
    );
  }
}
