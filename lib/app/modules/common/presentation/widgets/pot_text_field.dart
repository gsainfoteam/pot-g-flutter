import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pot_g/app/values/palette.dart';
import 'package:pot_g/app/values/text_styles.dart';

class PotTextField extends StatelessWidget {
  const PotTextField({
    super.key,
    this.suffixIcon,
    this.hintText,
    this.controller,
    this.readOnly = false,
    this.filled = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });
  final Widget? suffixIcon;
  final String? hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final bool filled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      style: TextStyles.body.copyWith(color: Palette.dark),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon:
            suffixIcon != null
                ? Padding(padding: const EdgeInsets.all(12), child: suffixIcon)
                : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: filled,
        fillColor: Color(0xfff5f5f5),
        hintText: hintText,
        hintStyle: TextStyle(color: Palette.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              filled ? BorderSide.none : BorderSide(color: Palette.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              filled ? BorderSide.none : BorderSide(color: Palette.borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              filled ? BorderSide.none : BorderSide(color: Palette.primary),
        ),
      ),
      controller: controller,
    );
  }
}
