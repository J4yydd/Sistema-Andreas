import 'package:flutter/material.dart';
import 'package:sistema_andreas/models/category.dart';
import 'package:sistema_andreas/utils/app_colors.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final MenuCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = ThemeData.estimateBrightnessForColor(category.color) ==
        Brightness.dark;
    final textColor = isDark ? AppColors.textOnDark : AppColors.textPrimary;
    final iconBackground = isDark
        ? AppColors.textOnDark.withValues(alpha: 0.22)
        : AppColors.surface.withValues(alpha: 0.9);
    final iconColor = isDark ? AppColors.textOnDark : category.color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: category.color,
            boxShadow: [
              BoxShadow(
                color: category.color.withValues(alpha: 0.55),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    category.icon,
                    size: 32,
                    color: iconColor,
                  ),
                ),
                Text(
                  category.name,
                  style: textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
