import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_date_picker.dart';
import '../../../../core/widgets/custom_drop_down.dart';
import '../../../../core/widgets/custom_text_field.dart';

class PersonalInfoCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController nationalNumberController;
  final DateTime? dateOfBirth;
  final String? gender;
  final Function(DateTime?) onDateSelected;
  final Function(String?) onGenderChanged;

  const PersonalInfoCard({
    super.key,
    required this.nameController,
    required this.nationalNumberController,
    required this.dateOfBirth,
    required this.gender,
    required this.onDateSelected,
    required this.onGenderChanged,
  });
  String _calulateAge(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;
    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += 12;
    }
    if (days < 0) {
      final monthDays = DateTime(now.year, now.month - 1, 0).day;
      days += monthDays;
      months--;
    }
    return '$years years, $months months, $days days';
  }

  String? _validateNameSyllables(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    // Split name into words
    final words = value.trim().split(' ');

    // Check if we have exactly 4 words
    if (words.length != 4) {
      return 'Please enter full name (4 parts)';
    }

    // Validate each word
    for (final word in words) {
      if (word.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(word)) {
        return 'Each name part should contain only letters';
      }
    }

    return null;
  }

  String? _validateDate(DateTime? date) {
    if (date == null) {
      return 'Date of birth is required';
    }

    if (date.isAfter(DateTime.now())) {
      return 'Date cannot be in the future';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: nameController,
              label: 'Full Name (4 parts)',
              prefixIcon: Icons.person,
              isRequired: true,
              validator: _validateNameSyllables,
              helperText: 'Enter first, second, third and family name',
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            CustomDatePicker(
              context: context,
              value: dateOfBirth,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: dateOfBirth ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  onDateSelected(picked);
                }
              },
              label: 'Date of Birth',
              isRequired: true,
              validator: _validateDate,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: TextEditingController(
                text: dateOfBirth != null
                    ? _calulateAge(dateOfBirth!)
                    : 'Please select date of birth',
              ),
              label: 'Age',
              prefixIcon: Icons.calendar_today,
              enabled: false,
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              value: gender,
              items: const ['Male', 'Female'],
              onChanged: onGenderChanged,
              label: 'Gender',
              prefixIcon: Icons.people,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: nationalNumberController,
              label: 'National Number',
              prefixIcon: Icons.numbers,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
