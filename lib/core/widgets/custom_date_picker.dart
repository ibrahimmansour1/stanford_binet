import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final BuildContext context;
  final DateTime? value;
  final VoidCallback onTap;
  final String label;
  final bool isRequired;
  final String? Function(DateTime?)? validator;

  const CustomDatePicker({
    super.key,
    required this.context,
    required this.value,
    required this.onTap,
    required this.label,
    this.isRequired = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: value,
      validator: validator ??
          (value) =>
              isRequired && value == null ? 'Please select $label' : null,
      builder: (FormFieldState<DateTime> state) {
        return InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: isRequired ? '$label *' : label,
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              prefixIcon: Icon(Icons.calendar_today,
                  color: Theme.of(context).primaryColor),
              errorText: state.errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
            ),
            child: Text(
              value?.toString().split(' ')[0] ?? 'Select date',
              style: value == null
                  ? TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.5))
                  : null,
            ),
          ),
        );
      },
    );
  }
}
