import 'package:flutter/material.dart';
import 'package:multi_role_flutter_auth/utils/constants/color.dart';
import 'package:multi_role_flutter_auth/utils/theme/widget_theme/checkbox_theme.dart';
import 'package:multi_role_flutter_auth/utils/theme/widget_theme/elevetad_button.dart';
import 'package:multi_role_flutter_auth/utils/theme/widget_theme/text_theme.dart';
import '../theme/widget_theme/outline_button.dart';


class HAppTheme {
  HAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: HColors.grey,
    brightness: Brightness.light,
    primaryColor: HColors.primary,

    textTheme: HTextTheme.lightTextTheme,
        /*chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    */
    checkboxTheme: HCheckboxTheme.lightCheckboxTheme,

    scaffoldBackgroundColor: HColors.primaryBackground,
        /*bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,*/
    elevatedButtonTheme: HElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: HOutlinedButtonTheme.lightOutlinedButtonTheme,
    /*inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,*/
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: HColors.grey,
    brightness: Brightness.dark,
    primaryColor: HColors.primary,
    textTheme: HTextTheme.darkTextTheme,/*
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,*/
    checkboxTheme: HCheckboxTheme.darkCheckboxTheme,
    scaffoldBackgroundColor: HColors.primary.withOpacity(0.1),
   /* bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,*/
    elevatedButtonTheme: HElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: HOutlinedButtonTheme.darkOutlinedButtonTheme,
    /*inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,*/
  );
}