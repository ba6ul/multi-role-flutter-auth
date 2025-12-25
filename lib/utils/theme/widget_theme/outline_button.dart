import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class HOutlinedButtonTheme {
  HOutlinedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme  = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: HColors.primary,
      side: const BorderSide(color: HColors.primary),
      padding: const EdgeInsets.symmetric(vertical: HSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HSizes.buttonRadius)),
      textStyle: const TextStyle(fontSize: 16, color: HColors.black, fontWeight: FontWeight.w600, fontFamily: 'Urbanist'),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: HColors.light,
      side: const BorderSide(color: HColors.borderPrimary),
      padding: const EdgeInsets.symmetric(vertical: HSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HSizes.buttonRadius)),
      textStyle: const TextStyle(fontSize: 16, color: HColors.textWhite, fontWeight: FontWeight.w600, fontFamily: 'Urbanist'),
    ),
  );
}