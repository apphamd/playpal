import 'package:flutter/material.dart';

class ChatTextFormField extends StatelessWidget {
  const ChatTextFormField({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
    this.hintText,
    this.onPressedSuffixIcon,
    this.onChanged,
  });

  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? labelText;
  final String? hintText;
  final VoidCallback? onPressedSuffixIcon;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
          suffixIcon: suffixIcon == null
              ? null
              : IconButton(
                  onPressed: onPressedSuffixIcon,
                  icon: Icon(suffixIcon),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.amber),
          )),
    );
  }
}