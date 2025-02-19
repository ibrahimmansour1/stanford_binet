import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_date_picker.dart';
import '../../../../core/widgets/custom_drop_down.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../generated/l10n.dart';

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
    return S.current.ageFormat(years, months, days);
  }

  String? _validateNameSyllables(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.nameRequired;
    }

    // Split name into words
    final words = value.trim().split(' ');

    // Check if we have exactly 4 words
    if (words.length != 4) {
      return S.current.namePartsValidation;
    }

    // Validate each word
    for (final word in words) {
      if (word.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(word)) {
        return S.current.nameLettersOnly;
      }
    }

    return null;
  }

  String? _validateDate(DateTime? date) {
    if (date == null) {
      return S.current.dateRequired;
    }

    if (date.isAfter(DateTime.now())) {
      return S.current.futureDateError;
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
            Text(
              S.current.personalInformation,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: nameController,
              label: S.current.fullNameLabel,
              prefixIcon: Icons.person,
              isRequired: true,
              validator: _validateNameSyllables,
              helperText: S.current.fullNameHelper,
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
