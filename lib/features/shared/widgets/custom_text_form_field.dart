import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null;
    const errorColor = Color.fromARGB(255, 163, 157, 157);

    final normalBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: hasError ? errorColor : const Color(0xFF3A7D3E),
        width: hasError ? 1.8 : 1.2,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: hasError ? errorColor : const Color(0xFF4CAF50),
        width: 1.8,
      ),
    );

    return TextFormField(
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.montserratAlternates(
        fontSize: 16,
        color: Colors.white,
      ),
      cursorColor: const Color(0xFF4CAF50),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.montserratAlternates(color: Colors.white70),
        hintText: hint, // using hint for hintText instead of hintText
        hintStyle: GoogleFonts.montserratAlternates(
          color: Colors.white38,
          fontSize: 16,
        ),
        enabledBorder: normalBorder,
        focusedBorder: focusedBorder,
        errorBorder: normalBorder,
        focusedErrorBorder: focusedBorder,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        errorText: errorMessage,
        errorStyle: GoogleFonts.montserratAlternates(
          color: errorColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
