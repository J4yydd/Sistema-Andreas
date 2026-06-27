import 'package:flutter/material.dart';

class FlavorOptionChip extends StatelessWidget {
  const FlavorOptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: selected ? colorScheme.primaryContainer : colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? colorScheme.primary : colorScheme.outline,
              width: selected ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
