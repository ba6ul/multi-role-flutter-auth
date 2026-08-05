import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class AuthField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;

  const AuthField({
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
    super.key,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? HColors.light : HColors.textPrimary;
    final labelColor = isDark
        ? HColors.light.withValues(alpha: 0.7)
        : HColors.textSecondary.withValues(alpha: 0.8);
    final hintColor = isDark
        ? HColors.light.withValues(alpha: 0.4)
        : HColors.textSecondary.withValues(alpha: 0.5);
    // Gold accent in dark mode reads far better against the near-black
    // background than the indigo primary, which nearly disappears there.
    final accentColor = isDark ? HColors.accent : HColors.primary;
    final fillColor = isDark ? HColors.darkContainer : HColors.white;
    final enabledBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : HColors.borderSecondary.withValues(alpha: 0.5);

    return TextFormField(
      controller: widget.controller,
      style: TextStyle(fontSize: HSizes.fontSizeMd, color: textColor),
      keyboardType: widget.keyboardType ?? TextInputType.text,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      obscureText: widget.obscureText && !_isPasswordVisible,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      cursorColor: accentColor,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: labelColor),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: hintColor, fontSize: HSizes.fontSizeSm),

        // Prefix Icon Styling
        prefixIcon: Icon(
          widget.prefixIcon,
          color: accentColor,
          size: HSizes.iconMd,
        ),

        // Suffix Icon for Passwords
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: accentColor.withValues(alpha: 0.7),
                  size: HSizes.iconMd,
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              )
            : null,

        // Unified Border Styling (Reduces redundancy)
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        border: _buildBorder(enabledBorderColor),
        enabledBorder: _buildBorder(enabledBorderColor),
        focusedBorder: _buildBorder(accentColor),
        errorBorder: _buildBorder(HColors.error),
        focusedErrorBorder: _buildBorder(HColors.error, width: 2.0),
      ),
    );
  }

  // Helper method to keep border code clean
  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(HSizes.inputFieldRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
