import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_drop_down.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ExamSettingsCard extends StatelessWidget {
  final TextEditingController originOfInformationController;
  final bool isSpeakerEnabled;
  final DateTime? examStartDate;
  final String? examKind;
  final Function(bool) onSpeakerToggled;
  final Function(DateTime?) onDateSelected;
  final Function(String?) onExamKindChanged;

  const ExamSettingsCard({
    super.key,
    required this.originOfInformationController,
    required this.isSpeakerEnabled,
    required this.examStartDate,
    required this.examKind,
    required this.onSpeakerToggled,
    required this.onDateSelected,
    required this.onExamKindChanged,
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
              'Exam Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: originOfInformationController,
              label: 'Origin of Information',
              prefixIcon: Icons.info,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading:
                  Icon(Icons.volume_up, color: Theme.of(context).primaryColor),
              title: Row(
                children: [
                  const Text('Speaker'),
                  Text(' *',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ],
              ),
              trailing: Switch(
                value: isSpeakerEnabled,
                onChanged: onSpeakerToggled,
                activeColor: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            // CustomDatePicker(
            //   context: context,
            //   value: examStartDate,
            //   onTap: () async {
            //     final picked = await showDatePicker(
            //       context: context,
            //       initialDate: DateTime.now(),
            //       firstDate: DateTime(1900),
            //       lastDate: DateTime.now(),
            //     );
            //     onDateSelected(picked);
            //   },
            //   label: 'Exam Start Date',
            // ),
            // const SizedBox(height: 16),
            CustomDropdown(
              value: examKind,
              items: const ['Battery', 'Spoken', 'Non Spoken', 'Touching'],
              onChanged: onExamKindChanged,
              label: 'Exam Kind',
              prefixIcon: Icons.assignment,
              isRequired: true,
            ),
          ],
        ),
      ),
    );
  }
}
