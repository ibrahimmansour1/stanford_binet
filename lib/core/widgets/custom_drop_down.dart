import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final String label;
  final IconData prefixIcon;
  final bool isRequired;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
    required this.prefixIcon,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        // labelStyle: TextStyle(color: theme.primaryColor),
        hintText: 'Select $label',
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
      ),
      icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor),
      validator: (value) =>
          isRequired && value == null ? 'Please select $label' : null,
    );
  }
}
