import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFFF4B3A);
  static const background = Color(0xFFF2F2F2);
  static const textDark = Color(0xFF333333);
  static const textLight = Color(0xFF8E8E93);
  static const white = Colors.white;
  static const black = Colors.black;
}

class AppStyles {
  static const title = TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark);
  static const subtitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark);
  static const body = TextStyle(fontSize: 14, color: AppColors.textLight);
}

class AppFormatters {
  static String currency(num amount) {
    final int rounded = amount.round();
    final str = rounded.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return 'Rs. $str';
  }
}

