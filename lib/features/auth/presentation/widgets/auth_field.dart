import 'package:flutter/material.dart';
import 'package:multi_role_flutter_auth/utils/constants/color.dart';
//import 'package:multi_role_flutter_auth/utils/constants/colors.dart';
import 'package:multi_role_flutter_auth/utils/constants/sizes.dart';
import 'package:multi_role_flutter_auth/utils/validators/validators.dart';

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

  const AuthField( {
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.onFieldSubmitted,
    super.key,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: const TextStyle(
        fontSize: HSizes.fontSizeMd,
        color: HColors.textPrimary,
      ),
      keyboardType: widget.keyboardType ?? TextInputType.text,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      obscureText: widget.obscureText && !_isPasswordVisible,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      cursorColor: HColors.primary,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: HColors.textSecondary.withValues(alpha: 0.8),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: HColors.textSecondary.withValues(alpha: 0.5),
          fontSize: HSizes.fontSizeSm,
        ),

        // Prefix Icon Styling
        prefixIcon: Icon(
          widget.prefixIcon,
          color: HColors.primary,
          size: HSizes.iconMd,
        ),

        // Suffix Icon for Passwords
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: HColors.primary.withValues(alpha: 0.7),
                  size: HSizes.iconMd,
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              )
            : null,

        // Unified Border Styling (Reduces redundancy)
        filled: true,
        fillColor: HColors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        border: _buildBorder(HColors.borderSecondary),
        enabledBorder: _buildBorder(
          HColors.borderSecondary.withValues(alpha: 0.5),
        ),
        focusedBorder: _buildBorder(HColors.primary),
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
