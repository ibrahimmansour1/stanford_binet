import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_drop_down.dart';
import '../../../../core/widgets/custom_text_field.dart';

class EducationalInfoCard extends StatelessWidget {
  final TextEditingController schoolController;
  final TextEditingController gradeController;
  final String? languageOfChild;
  final Function(String?) onLanguageChanged;

  const EducationalInfoCard({
    super.key,
    required this.schoolController,
    required this.gradeController,
    required this.languageOfChild,
    required this.onLanguageChanged,
  });

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
              'Educational Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              value: languageOfChild,
              items: const ['English', 'French', 'Arabic'],
              onChanged: onLanguageChanged,
              label: 'Language of Child',
              prefixIcon: Icons.language,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: schoolController,
              label: 'School',
              prefixIcon: Icons.school,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: gradeController,
              label: 'Grade in School',
              prefixIcon: Icons.grade,
            ),
          ],
        ),
      ),
    );
  }
}
