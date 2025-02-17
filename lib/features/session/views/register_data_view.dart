import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
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
      try {
        // Generate a unique session code
        final Random random = Random();
        const int codeLength = 6;
        String sessionCode =
            List.generate(codeLength, (_) => random.nextInt(10))
                .join(); // Generates a 6-digit random number

        // Fetch all question IDs from the 'questions' collection
        final questionsSnapshot =
            await FirebaseFirestore.instance.collection('questions').get();

        final questionIds =
            questionsSnapshot.docs.map((doc) => doc.id).toList();

        // Save data to Firestore
        await FirebaseFirestore.instance
            .collection('sessions')
            .doc(sessionCode)
            .set({
          'name': _nameController.text,
          'date_of_birth': _dateOfBirth?.toIso8601String(),
          'gender': _gender,
          'national_number': _nationalNumberController.text,
          'language_of_child': _languageOfChild,
          'school': _schoolController.text,
          'grade_in_school': _gradeController.text,
          'origin_of_information': _originOfInformationController.text,
          'is_speaker_enabled': _isSpeakerEnabled,
          'exam_start_date': _examStartDate?.toIso8601String(),
          'exam_kind': _examKind,
          'session_code': sessionCode, // Add the session code
          'createdAt': FieldValue.serverTimestamp(),
          'question_ids': questionIds, // Add all question IDs
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Data saved successfully! Session Code: $sessionCode'),
            duration: const Duration(seconds: 5),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
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
                Card(
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Name',
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        _buildDatePicker(
                          context: context,
                          value: _dateOfBirth,
                          onTap: () => _selectDate(context),
                          label: 'Date of Birth',
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          value: _gender,
                          items: ['Male', 'Female'],
                          onChanged: (value) => setState(() => _gender = value),
                          label: 'Gender',
                          prefixIcon: Icons.people,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _nationalNumberController,
                          label: 'National Number',
                          prefixIcon: Icons.numbers,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          value: _languageOfChild,
                          items: ['English', 'French', 'Arabic'],
                          onChanged: (value) =>
                              setState(() => _languageOfChild = value),
                          label: 'Language of Child',
                          prefixIcon: Icons.language,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _schoolController,
                          label: 'School',
                          prefixIcon: Icons.school,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _gradeController,
                          label: 'Grade in School',
                          prefixIcon: Icons.grade,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _originOfInformationController,
                          label: 'Origin of Information',
                          prefixIcon: Icons.info,
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.volume_up),
                          title: const Text('Speaker Enabled'),
                          trailing: Switch(
                            value: _isSpeakerEnabled,
                            onChanged: (value) =>
                                setState(() => _isSpeakerEnabled = value),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDatePicker(
                          context: context,
                          value: _examStartDate,
                          onTap: () => _selectDate(context, isExamDate: true),
                          label: 'Exam Start Date',
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          value: _examKind,
                          items: [
                            'Battery',
                            'Spoken',
                            'Non Spoken',
                            'Touching'
                          ],
                          onChanged: (value) =>
                              setState(() => _examKind = value),
                          label: 'Exam Kind',
                          prefixIcon: Icons.assignment,
                        ),
                      ],
                    ),
                  ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String label,
    required IconData prefixIcon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required DateTime? value,
    required VoidCallback onTap,
    required String label,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          value == null
              ? 'Select $label'
              : value.toLocal().toString().substring(0, 10),
        ),
      ),
    );
  }
}
