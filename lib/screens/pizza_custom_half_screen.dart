import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_ingredient.dart';
import 'package:sistema_andreas/models/pizza_size.dart';
import 'package:sistema_andreas/utils/custom_ingredient_pricing.dart';
import 'package:sistema_andreas/utils/custom_ingredients_data.dart';
import 'package:sistema_andreas/utils/price_formatter.dart';
import 'package:sistema_andreas/widgets/flavor_option_chip.dart';

class PizzaCustomHalfScreen extends StatefulWidget {
  const PizzaCustomHalfScreen({
    super.key,
    required this.pizzaSize,
    required this.isHalfPortion,
    this.initialData,
  });

  final PizzaSize pizzaSize;
  final bool isHalfPortion;
  final PizzaCustomHalfData? initialData;

  @override
  State<PizzaCustomHalfScreen> createState() => _PizzaCustomHalfScreenState();
}

class _PizzaCustomHalfScreenState extends State<PizzaCustomHalfScreen> {
  late final Set<String> _selectedIngredientIds;

  @override
  void initState() {
    super.initState();
    _selectedIngredientIds = {...?widget.initialData?.ingredientIds};
  }

  bool get _canConfirm => _selectedIngredientIds.isNotEmpty;

  PizzaHalfSelection get _previewHalf => PizzaHalfSelection(
        flavorId: CustomIngredientsData.personalizadoId,
        customData: PizzaCustomHalfData(
          ingredientIds: _selectedIngredientIds.toList(),
        ),
      );

  double get _extraCost {
    if (_selectedIngredientIds.length <= 3) return 0;
    return calculateCustomHalfExtraCost(
      widget.pizzaSize,
      _previewHalf,
      isSplitPizza: widget.isHalfPortion,
    );
  }

  String get _previewLabel {
    if (_selectedIngredientIds.isEmpty) {
      return 'Elige tus ingredientes';
    }

    final names = CustomIngredientsData.ingredientNames(
      _selectedIngredientIds.toList(),
    );
    return names.join(', ');
  }

  void _toggleIngredient(String id) {
    setState(() {
      if (_selectedIngredientIds.contains(id)) {
        _selectedIngredientIds.remove(id);
      } else {
        _selectedIngredientIds.add(id);
      }
    });
  }

  void _confirm() {
    if (!_canConfirm) return;
    Navigator.of(context).pop(_previewHalf);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizado'),
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
                  widget.pizzaSize.name,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _previewLabel,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
                if (_extraCost > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '+ ${formatPrice(_extraCost)} ingredientes extra',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Ingredientes',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hasta 3 sin costo extra · Más de 3 aplican cargo',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final ingredient in CustomIngredientsData.ingredients)
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 42) / 2,
                        child: FlavorOptionChip(
                          label: ingredient.name,
                          selected:
                              _selectedIngredientIds.contains(ingredient.id),
                          onTap: () => _toggleIngredient(ingredient.id),
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
                onPressed: _canConfirm ? _confirm : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Confirmar personalizado',
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
