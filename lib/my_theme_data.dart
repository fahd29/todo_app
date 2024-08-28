import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/app_colors.dart';

class MyThemeData {
  static final ThemeData lightTheme = ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme:
          AppBarTheme(elevation: 0, backgroundColor: AppColors.primaryColor),
      bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15)))),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.grayColor,
        showUnselectedLabels: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor),
        titleMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor),
        bodyLarge: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor),
        bodyMedium: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: AppColors.blackColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryColor,
          shape: StadiumBorder(
              side: BorderSide(color: AppColors.whiteColor, width: 4))));

  static final ThemeData darkMode = ThemeData(
      primaryColor: AppColors.blackDarkColor,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme:
          AppBarTheme(elevation: 0, backgroundColor: AppColors.primaryColor),
      bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15)))),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.grayColor,
        showUnselectedLabels: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor),
        titleMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor),
        bodyLarge: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor),
        bodyMedium: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: AppColors.blackColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryColor,
          shape: StadiumBorder(
              side: BorderSide(color: AppColors.whiteColor, width: 4))));
}
