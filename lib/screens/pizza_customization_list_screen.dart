import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_size.dart';
import 'package:sistema_andreas/screens/pizza_flavor_screen.dart';
import 'package:sistema_andreas/utils/app_colors.dart';
import 'package:sistema_andreas/utils/pizza_flavors_data.dart';

class PizzaCustomizationListScreen extends StatefulWidget {
  const PizzaCustomizationListScreen({
    super.key,
    required this.pizzaSize,
    required this.quantity,
    required this.initialCustomizations,
  });

  final PizzaSize pizzaSize;
  final int quantity;
  final Map<int, PizzaFlavorSelection> initialCustomizations;

  @override
  State<PizzaCustomizationListScreen> createState() =>
      _PizzaCustomizationListScreenState();
}

class _PizzaCustomizationListScreenState
    extends State<PizzaCustomizationListScreen> {
  late Map<int, PizzaFlavorSelection> _customizations;

  @override
  void initState() {
    super.initState();
    _customizations = Map.from(widget.initialCustomizations);
  }

  Future<void> _openPizza(int index) async {
    final result = await Navigator.of(context).push<PizzaFlavorSelection>(
      MaterialPageRoute(
        builder: (_) => PizzaFlavorScreen(
          pizzaSize: widget.pizzaSize,
          pizzaIndex: index,
          initialSelection: _customizations[index],
        ),
      ),
    );

    if (result != null) {
      setState(() => _customizations[index] = result);
    }
  }

  void _saveAndClose() {
    Navigator.of(context).pop(_customizations);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final allConfigured = List.generate(
      widget.quantity,
      (i) => _customizations[i + 1]?.isComplete ?? false,
    ).every((configured) => configured);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personalizar',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textOnDark,
              ),
            ),
            Text(
              '${widget.pizzaSize.name} · ${widget.quantity} pizza${widget.quantity == 1 ? '' : 's'}',
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
              itemCount: widget.quantity,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pizzaNumber = index + 1;
                final selection = _customizations[pizzaNumber];
                final label = PizzaFlavorsData.selectionLabel(selection);
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
                    onTap: () => _openPizza(pizzaNumber),
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
                              '$pizzaNumber',
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
                                  'Pizza $pizzaNumber',
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
                  allConfigured ? 'Listo' : 'Configura todas las pizzas',
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
