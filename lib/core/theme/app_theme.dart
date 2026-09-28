import 'package:academy_management_system/core/theme/app_colors.dart';
import 'package:academy_management_system/core/theme/apptypography.dart';
import 'package:flutter/material.dart';

/// Unified design system for the Academy management dashboard.
/// Premium, minimal, SaaS-style tokens shared by every screen.
class AppTheme {
  // ---- Brand ----
  static const primary = Color(0xFF0F766E);
  static const primaryStrong = Color(0xFF0B5F57);
  static const primarySoft = Color(0xFFE4F0ED);
  static const accent = Color(0xFF2E90FA);

  // ---- Surfaces ----
  static const canvas = const Color(0xFFFFFCF8);
  static const surface = Color(0xFFFFFFFF);
  static const sidebarSurface = Color(0xFFFAFBFC);

  // ---- Text ----
  static const ink = Color(0xFF101828);
  static const body = Color(0xFF344054);
  static const muted = Color(0xFF667085);
  static const subtle = Color(0xFF98A2B3);

  // ---- Lines & fills ----
  static const border = Color(0xFFE4E7EC);
  static const borderStrong = Color(0xFFD0D5DD);
  static const hover = Color(0xFFF2F4F7);

  // ---- Semantic ----
  static const success = Color(0xFF12B76A);
  static const successSoft = Color(0xFFE5F6EC);
  static const warning = Color(0xFFF79009);
  static const warningSoft = Color(0xFFFFF4E0);
  static const danger = Color(0xFFF04438);
  static const dangerSoft = Color(0xFFFDECEB);
  static const info = Color(0xFF2E90FA);
  static const infoSoft = Color(0xFFEFF6FD);

  // ---- Geometry ----
  static const radiusSm = 8.0;
  static const radiusMd = 12.0;
  static const radiusLg = 16.0;
  static const radiusXl = 20.0;

  // ---- Typography ----
  static const fontFamily = 'Cairo';
  // static const fontFamilyFallback = <String>['Tahoma', 'Arial'];

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      surface: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      fontFamily: fontFamily,
      textTheme: TextTheme(
        displayLarge: AppTypography.h1.copyWith(color: AppColors.textPrimary),
        displayMedium: AppTypography.h2.copyWith(color: AppColors.textPrimary),
        displaySmall: AppTypography.h3.copyWith(color: AppColors.textPrimary),
        headlineMedium: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      // fontFamilyFallback: fontFamilyFallback,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shadowColor: const Color(0x1A0F172A),
        surfaceTintColor: const Color(0x00000000),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE4E7EC), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: Color(0xFFD0D5DD), width: 1),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStatePropertyAll<Color?>(
          const Color(0xFFF7F8FA),
        ),
        headingRowHeight: 46,
        headingTextStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475467),
        ),
        dataRowColor: WidgetStateProperty<Color?>.fromMap(<WidgetState, Color?>{
          WidgetState.hovered: const Color(0xFFF2F5F9),
        }),
        dataRowMinHeight: 54,
        dataRowMaxHeight: 76,
        dataTextStyle: const TextStyle(
          fontSize: 13.5,
          color: Color(0xFF101828),
        ),
        dividerThickness: 1,
        columnSpacing: 26,
        horizontalMargin: 20,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 12,
        shadowColor: const Color(0x2E0F172A),
        titleTextStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        contentTextStyle: const TextStyle(fontSize: 13.5, color: body),
        actionsPadding: const EdgeInsets.fromLTRB(0, 14, 0, 6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          iconColor: Colors.white,
          iconSize: 16,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: body,
          iconColor: body,
          iconSize: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Color(0xFFD0D5DD), width: 1),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: body,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(iconSize: 18),
      ),
    );
  }
}
