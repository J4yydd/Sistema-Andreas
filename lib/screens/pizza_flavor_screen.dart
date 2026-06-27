import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/pizza_flavor.dart';
import 'package:sistema_andreas/models/pizza_size.dart';
import 'package:sistema_andreas/screens/pizza_custom_half_screen.dart';
import 'package:sistema_andreas/utils/pizza_extras_data.dart';
import 'package:sistema_andreas/utils/pizza_flavors_data.dart';
import 'package:sistema_andreas/utils/price_formatter.dart';
import 'package:sistema_andreas/widgets/flavor_option_chip.dart';

class PizzaFlavorScreen extends StatefulWidget {
  const PizzaFlavorScreen({
    super.key,
    required this.pizzaSize,
    required this.pizzaIndex,
    this.initialSelection,
  });

  final PizzaSize pizzaSize;
  final int pizzaIndex;
  final PizzaFlavorSelection? initialSelection;

  @override
  State<PizzaFlavorScreen> createState() => _PizzaFlavorScreenState();
}

class _PizzaFlavorScreenState extends State<PizzaFlavorScreen> {
  final List<PizzaHalfSelection> _halves = [];
  late final TextEditingController _notesController;
  String? _pendingPolloFlavorId;
  bool _cheeseCrust = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelection != null) {
      _halves.addAll(widget.initialSelection!.halves);
      _cheeseCrust = widget.initialSelection!.cheeseCrust;
    }
    _notesController = TextEditingController(
      text: widget.initialSelection?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  PizzaFlavorSelection get _currentSelection => PizzaFlavorSelection(
        halves: List.unmodifiable(_halves),
        notes: _notesController.text.trim(),
        cheeseCrust: _cheeseCrust,
      );

  String get _currentLabel {
    if (_halves.isEmpty && _pendingPolloFlavorId == null) {
      return 'Selecciona el sabor';
    }
    return PizzaFlavorsData.selectionLabel(_currentSelection);
  }

  bool get _canConfirm =>
      _halves.isNotEmpty && _pendingPolloFlavorId == null;

  int? _indexOfHalf(PizzaHalfSelection half) {
    for (var i = 0; i < _halves.length; i++) {
      if (PizzaFlavorsData.isHalfSelected([_halves[i]], half)) {
        return i;
      }
    }
    return null;
  }

  void _addOrReplaceHalf(PizzaHalfSelection half) {
    setState(() {
      _pendingPolloFlavorId = null;

      final existingIndex = _indexOfHalf(half);
      if (existingIndex != null) {
        _halves.removeAt(existingIndex);
        return;
      }

      if (half.flavorId == PizzaFlavorsData.personalizadoId) {
        final personalizadoIndex =
            PizzaFlavorsData.indexOfPersonalizadoHalf(_halves);
        if (personalizadoIndex != null) {
          _halves[personalizadoIndex] = half;
          return;
        }
      }

      if (_halves.length < 2) {
        _halves.add(half);
        return;
      }

      _halves[1] = half;
    });
  }

  void _onFlavorTap(PizzaFlavor flavor) {
    if (flavor.isCustomBuilder) {
      _openPersonalizado();
      return;
    }

    if (flavor.requiresSubOption) {
      setState(() => _pendingPolloFlavorId = flavor.id);
      return;
    }

    _addOrReplaceHalf(PizzaHalfSelection(flavorId: flavor.id));
  }

  bool _isHalfPortionForCustom() {
    if (_halves.isEmpty) return false;
    if (_halves.length >= 2) return true;

    final personalizadoIndex =
        PizzaFlavorsData.indexOfPersonalizadoHalf(_halves);
    if (personalizadoIndex != null) return false;

    return true;
  }

  Future<void> _openPersonalizado() async {
    final existingIndex =
        PizzaFlavorsData.indexOfPersonalizadoHalf(_halves);
    final initialData =
        existingIndex != null ? _halves[existingIndex].customData : null;

    final result = await Navigator.of(context).push<PizzaHalfSelection>(
      MaterialPageRoute(
        builder: (_) => PizzaCustomHalfScreen(
          pizzaSize: widget.pizzaSize,
          isHalfPortion: _isHalfPortionForCustom(),
          initialData: initialData,
        ),
      ),
    );

    if (result == null) return;

    setState(() {
      _pendingPolloFlavorId = null;

      if (existingIndex != null) {
        _halves[existingIndex] = result;
        return;
      }

      if (_halves.length < 2) {
        _halves.add(result);
        return;
      }

      _halves[1] = result;
    });
  }

  void _onSubOptionTap(PizzaFlavorSubOption option) {
    if (_pendingPolloFlavorId == null) return;

    _addOrReplaceHalf(
      PizzaHalfSelection(
        flavorId: _pendingPolloFlavorId!,
        subOptionId: option.id,
      ),
    );
  }

  void _confirmSelection() {
    if (!_canConfirm) return;
    Navigator.of(context).pop(_currentSelection);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final pendingPollo = _pendingPolloFlavorId != null
        ? PizzaFlavorsData.findById(_pendingPolloFlavorId!)
        : null;
    final personalizadoSelected = PizzaFlavorsData.isFlavorIdSelected(
      _halves,
      PizzaFlavorsData.personalizadoId,
    );
    final cheeseCrustPrice = widget.pizzaSize.cheeseCrustPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pizza ${widget.pizzaIndex}'),
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
                  _currentLabel,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
                if (_halves.length == 1 && _pendingPolloFlavorId == null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Puedes elegir otra mitad',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
                  'Sabores',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Elige 1 sabor o 2 mitades',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final flavor in PizzaFlavorsData.flavors)
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 42) / 2,
                        child: FlavorOptionChip(
                          label: flavor.name,
                          selected: flavor.requiresSubOption
                              ? _pendingPolloFlavorId == flavor.id ||
                                  PizzaFlavorsData.isFlavorIdSelected(
                                    _halves,
                                    flavor.id,
                                  )
                              : PizzaFlavorsData.isHalfSelected(
                                  _halves,
                                  PizzaHalfSelection(flavorId: flavor.id),
                                ),
                          onTap: () => _onFlavorTap(flavor),
                        ),
                      ),
                  ],
                ),
                if (cheeseCrustPrice != null) ...[
                  const SizedBox(height: 28),
                  Text(
                    'Extras',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: (MediaQuery.sizeOf(context).width - 42) / 2,
                    child: FlavorOptionChip(
                      label:
                          '${PizzaExtrasData.cheeseCrustLabel} (+ ${formatPrice(cheeseCrustPrice)})',
                      selected: _cheeseCrust,
                      onTap: () => setState(() => _cheeseCrust = !_cheeseCrust),
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                Text(
                  'Notas especiales',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ej: no la quiero muy dorada, sin cebolla, etc.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  onChanged: (_) => setState(() {}),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Escribe aquí tus indicaciones...',
                  ),
                ),
                if (pendingPollo != null) ...[
                  const SizedBox(height: 28),
                  Text(
                    'Tipo de ${pendingPollo.name}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final option in pendingPollo.subOptions)
                        SizedBox(
                          width: (MediaQuery.sizeOf(context).width - 42) / 2,
                          child: FlavorOptionChip(
                            label: option.name,
                            selected: PizzaFlavorsData.isHalfSelected(
                              _halves,
                              PizzaHalfSelection(
                                flavorId: pendingPollo.id,
                                subOptionId: option.id,
                              ),
                            ),
                            onTap: () => _onSubOptionTap(option),
                          ),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 28),
                Text(
                  'Especial',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Material(
                  color: personalizadoSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    onTap: _openPersonalizado,
                    borderRadius: BorderRadius.circular(18),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: personalizadoSelected
                              ? colorScheme.primary
                              : colorScheme.outline,
                          width: personalizadoSelected ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Icon(
                              Icons.restaurant_menu_rounded,
                              color: personalizadoSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    PizzaFlavorsData.personalizado.name,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Elige tus propios ingredientes',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
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
                  ),
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
