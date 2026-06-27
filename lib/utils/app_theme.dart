import 'package:flutter/material.dart';
import 'package:sistema_andreas/utils/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.textPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textPrimary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.textPrimary,
      tertiary: AppColors.accent,
      onTertiary: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.borderStrong,
      outlineVariant: AppColors.border,
      shadow: AppColors.primary,
      scrim: AppColors.textPrimary,
      inverseSurface: AppColors.appBar,
      onInverseSurface: AppColors.textOnDark,
      inversePrimary: AppColors.primaryLight,
      surfaceTint: AppColors.primary,
      tertiaryContainer: AppColors.accent,
      onTertiaryContainer: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surface,
      surfaceContainerHigh: AppColors.background,
      surfaceContainer: AppColors.background,
      surfaceContainerLow: AppColors.background,
      surfaceContainerLowest: AppColors.background,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: AppColors.textPrimary),
        titleLarge: TextStyle(color: AppColors.textPrimary),
        titleMedium: TextStyle(color: AppColors.textPrimary),
        titleSmall: TextStyle(color: AppColors.textPrimary),
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
        bodySmall: TextStyle(color: AppColors.textSecondary),
        labelLarge: TextStyle(color: AppColors.textPrimary),
        labelMedium: TextStyle(color: AppColors.textPrimary),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 2,
        scrolledUnderElevation: 4,
        shadowColor: AppColors.primary,
        backgroundColor: AppColors.appBar,
        foregroundColor: AppColors.textOnDark,
        iconTheme: IconThemeData(color: AppColors.accent),
        actionsIconTheme: IconThemeData(color: AppColors.accent),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surface,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: AppColors.primary.withValues(alpha: 0.25),
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textSecondary,
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.appBar,
        contentTextStyle: TextStyle(color: AppColors.textOnDark),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }
}
