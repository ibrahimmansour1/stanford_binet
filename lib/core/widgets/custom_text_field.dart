import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool isRequired;
  final bool? enabled;
  final String? Function(String?)? validator;
  final String? helperText;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.enabled,
    this.keyboardType,
    this.isRequired = false,
    this.validator,
    this.helperText,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      enabled: enabled ?? true,
      controller: controller,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        // labelStyle: TextStyle(color: theme.primaryColor),
        hintText: 'Enter $label',
        // hintStyle: TextStyle(color: theme.primaryColor.withOpacity(0.5)),
        prefixIcon: Icon(prefixIcon, color: theme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        helperText: helperText,
        helperStyle: TextStyle(color: theme.primaryColor),
      ),
      keyboardType: keyboardType,
      validator: validator ??
          (isRequired
              ? (value) => value?.isEmpty ?? true ? 'Please enter $label' : null
              : null),
      textCapitalization: textCapitalization,
    );
  }
}
