import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

sealed class AppTheme {
  static ThemeData light() {
    final TextTheme textTheme = GoogleFonts.cairoTextTheme().copyWith(
      headlineSmall: GoogleFonts.cairo(fontWeight: FontWeight.w700),
      titleLarge: GoogleFonts.cairo(fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.cairo(fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.cairo(fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.cairo(fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.cairo(fontWeight: FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brand,
        primary: AppColors.brand,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.canvasTop,
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 52),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brand,
          minimumSize: const Size(0, 52),
          side: const BorderSide(color: AppColors.outlineSoft),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.outlineSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.outlineSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.brand, width: 1.2),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final TextTheme textTheme =
        GoogleFonts.cairoTextTheme(
          ThemeData.dark(useMaterial3: true).textTheme,
        ).copyWith(
          headlineSmall: GoogleFonts.cairo(fontWeight: FontWeight.w700),
          titleLarge: GoogleFonts.cairo(fontWeight: FontWeight.w600),
          titleMedium: GoogleFonts.cairo(fontWeight: FontWeight.w600),
          bodyLarge: GoogleFonts.cairo(fontWeight: FontWeight.w500),
          bodyMedium: GoogleFonts.cairo(fontWeight: FontWeight.w400),
          labelLarge: GoogleFonts.cairo(fontWeight: FontWeight.w600),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.brand,
        primary: AppColors.accent,
        secondary: AppColors.brand,
        surface: AppColors.surfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.brandDark,
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: textTheme.apply(
        bodyColor: AppColors.textOnDark,
        displayColor: AppColors.textOnDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.textOnDark,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.brandDark,
          minimumSize: const Size(0, 52),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textOnDark,
          minimumSize: const Size(0, 52),
          side: const BorderSide(color: AppColors.outlineSoft),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.outlineSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.outlineSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
        ),
      ),
    );
  }
}
