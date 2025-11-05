// lib/common/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:livria_user/common/theme/app_colors.dart';


ThemeData getAppTheme() {
  return ThemeData(

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryOrange,
      unselectedItemColor: AppColors.black,
      elevation: 0,

      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Alexandria',
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    ),



    // Default Font
    fontFamily: 'Alexandria',



    // Text Theme
    textTheme: const TextTheme(

      // Titles
      headlineLarge: TextStyle(
        fontFamily: 'AsapCondensed',
        fontWeight: FontWeight.w700, // .bold
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'AsapCondensed',
        fontWeight: FontWeight.w700, // .bold
        fontSize: 28,
      ),

      // Body
      bodyLarge: TextStyle(
        fontFamily: 'Alexandria',
        fontWeight: FontWeight.w400, // .regular
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Alexandria',
        fontWeight: FontWeight.w500, // .medium
        fontSize: 14,
      ),

      // Button
      labelLarge: TextStyle(
        fontFamily: 'Alexandria',
        fontWeight: FontWeight.w700, // .bold
        fontSize: 16,
        letterSpacing: 1,
      ),
    ),
  );
}