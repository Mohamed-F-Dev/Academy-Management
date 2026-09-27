import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTypography {
  AppTypography._();

  // اسم العائلة كما هو معرف بالضبط في الـ pubspec.yaml
  static String get fontFamily => "Cairo";

  /// ================= HEADINGS =================

  static TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: (32.sp).clamp(30.0, 38.0).toDouble(),
    fontWeight: FontWeight.bold, // سيستخدم Cairo-Bold تلقائياً
    letterSpacing: -0.5,
    color: Colors.black, // استبدله بـ AppColors.textPrimary
    height: 1.2,
  );

  static TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: (24.sp).clamp(21.0, 30.0).toDouble(),
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: Colors.black,
  );

  static TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: (20.sp).clamp(18.0, 24.0).toDouble(),
    fontWeight: FontWeight.w600, // سيستخدم Cairo-SemiBold تلقائياً
    height: 1.4,
    color: Colors.black,
  );

  static TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: (18.sp).clamp(16.0, 22.0).toDouble(),
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: Colors.black,
  );

  static TextStyle h5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: (16.sp).clamp(15.0, 20.0).toDouble(),
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: Colors.black,
  );

  static TextStyle h6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: (14.sp).clamp(13.0, 18.0).toDouble(),
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: Colors.black,
  );

  /// ================= BODY =================

  static TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: (16.sp).clamp(15.0, 20.0).toDouble(),
    fontWeight: FontWeight.normal, // سيستخدم Cairo-Regular
    height: 1.5,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: (14.sp).clamp(13.0, 18.0).toDouble(),
    height: 1.5,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: (12.sp).clamp(11.0, 14.0).toDouble(),
    height: 1.5,
  );

  /// ================= BUTTON =================

  static TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: (14.sp).clamp(13.0, 16.0).toDouble(),
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  /// ================= CAPTION =================

  static TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: (12.sp).clamp(11.0, 14.0).toDouble(),
    height: 1.3,
  );

  static TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: (10.sp).clamp(9.0, 12.0).toDouble(),
    fontWeight: FontWeight.w500, // سيستخدم Cairo-Medium
    letterSpacing: 1.5,
  );

  /// ================= LABELS =================

  static TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: (14.sp).clamp(13.0, 16.0).toDouble(),
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: (12.sp).clamp(11.0, 14.0).toDouble(),
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: (11.sp).clamp(10.0, 13.0).toDouble(),
    fontWeight: FontWeight.w500,
  );
}
