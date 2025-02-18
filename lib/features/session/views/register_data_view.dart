import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stanford_binet/features/session/services/register_service.dart';

import '../services/date_service.dart';
import 'widgets/educational_info_card.dart';
import 'widgets/exam_settings_card.dart';
import 'widgets/personal_info_card.dart';

class RegisterDataView extends ConsumerStatefulWidget {
  const RegisterDataView({super.key});

  @override
  _RegisterDataViewState createState() => _RegisterDataViewState();
}

class _RegisterDataViewState extends ConsumerState<RegisterDataView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nationalNumberController;
  late TextEditingController _schoolController;
  late TextEditingController _gradeController;
  late TextEditingController _originOfInformationController;

  String? _gender;
  String? _languageOfChild;
  String? _examKind;
  DateTime? _dateOfBirth;
  DateTime? _examStartDate;
  bool _isSpeakerEnabled = true;
  String? _sessionCode; // Unique session code

  final _sessionService = RegisterService();
  final _dateService = DateService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nationalNumberController = TextEditingController();
    _schoolController = TextEditingController();
    _gradeController = TextEditingController();
    _originOfInformationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nationalNumberController.dispose();
    _schoolController.dispose();
    _gradeController.dispose();
    _originOfInformationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context,
      {bool isExamDate = false}) async {
    final picked = await _dateService.selectDate(context);
    if (picked != null && mounted) {
      setState(() {
        if (isExamDate) {
          _examStartDate = picked;
        } else {
          _dateOfBirth = picked;
        }
      });
    }
  }

  Future<void> _saveDataToFirebase(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_gender == null || _examKind == null || _dateOfBirth == null) {
        _sessionService.showValidationError(context);
        return;
      }

      try {
        final sessionCode = await _sessionService.generateSessionCode();
        final questionIds = await _sessionService.fetchQuestionIds();

        await _sessionService.saveSession(
          sessionCode: sessionCode,
          name: _nameController.text,
          dateOfBirth: _dateOfBirth,
          gender: _gender,
          nationalNumber: _nationalNumberController.text,
          languageOfChild: _languageOfChild,
          school: _schoolController.text,
          grade: _gradeController.text,
          originOfInformation: _originOfInformationController.text,
          isSpeakerEnabled: _isSpeakerEnabled,
          // examStartDate: _examStartDate,
          examKind: _examKind,
          questionIds: questionIds,
        );

        _sessionService.showSuccessMessage(context, sessionCode);
        // Navigator.pop(context);
      } catch (e) {
        _sessionService.showErrorMessage(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Session Data'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                PersonalInfoCard(
                  nameController: _nameController,
                  nationalNumberController: _nationalNumberController,
                  dateOfBirth: _dateOfBirth,
                  gender: _gender,
                  onDateSelected: (date) {
                    if (date != null && mounted) {
                      setState(() => _dateOfBirth = date);
                    }
                  },
                  onGenderChanged: (value) => setState(() => _gender = value),
                ),
                const SizedBox(height: 16),
                EducationalInfoCard(
                  schoolController: _schoolController,
                  gradeController: _gradeController,
                  languageOfChild: _languageOfChild,
                  onLanguageChanged: (value) =>
                      setState(() => _languageOfChild = value),
                ),
                const SizedBox(height: 16),
                ExamSettingsCard(
                  originOfInformationController: _originOfInformationController,
                  isSpeakerEnabled: _isSpeakerEnabled,
                  examStartDate: _examStartDate,
                  examKind: _examKind,
                  onSpeakerToggled: (value) =>
                      setState(() => _isSpeakerEnabled = value),
                  onDateSelected: (date) {
                    if (date != null && mounted) {
                      setState(() => _examStartDate = date);
                    }
                  },
                  onExamKindChanged: (value) =>
                      setState(() => _examKind = value),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => _saveDataToFirebase(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Data',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
