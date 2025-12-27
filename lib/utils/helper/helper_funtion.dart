import 'package:flutter/material.dart';

class HHelperFunctions {

  static bool isDarkMode(BuildContext context) {
    return Theme
        .of(context)
        .brightness == Brightness.dark;
  }


}