import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/services/toast_service.dart';
import '../../../generated/l10n.dart';

class RegisterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> generateSessionCode() async {
    final Random random = Random();
    const int codeLength = 6;
    return List.generate(codeLength, (_) => random.nextInt(10)).join();
  }

  Future<List<String>> fetchQuestionIds() async {
    final questionsSnapshot = await _firestore.collection('questions').get();
    return questionsSnapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> saveSession({
    required String sessionCode,
    required String name,
    required DateTime? dateOfBirth,
    required String? gender,
    required String nationalNumber,
    required String? languageOfChild,
    required String school,
    required String grade,
    required String originOfInformation,
    required bool isSpeakerEnabled,
    // required DateTime? examStartDate,
    required String? examKind,
    required List<String> questionIds,
  }) async {
    await _firestore.collection('sessions').doc(sessionCode).set({
      'name': name,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'national_number': nationalNumber,
      'language_of_child': languageOfChild,
      'school': school,
      'grade_in_school': grade,
      'origin_of_information': originOfInformation,
      'is_speaker_enabled': isSpeakerEnabled,
      // 'exam_start_date': examStartDate?.toIso8601String(),
      'exam_kind': examKind,
      'session_code': sessionCode,
      'createdAt': FieldValue.serverTimestamp(),
      'question_ids': questionIds,
    });
  }

  void showSuccessMessage(BuildContext context, String sessionCode) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: S.of(context).successMessage(sessionCode),
      titleTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Text(
              S.of(context).successMessage(sessionCode),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    S.of(context).sessionCode,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    sessionCode,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: sessionCode),
                            );
                            setState(() => _isCopied = true);
                            await Future.delayed(
                              const Duration(seconds: 2),
                              () => setState(() => _isCopied = false),
                            );
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    _isCopied ? Icons.check_circle : Icons.copy,
                                    key: ValueKey<bool>(_isCopied),
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isCopied ? 'Copied!' : 'Copy Code',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      btnOkText: 'Done',
      btnOkColor: Colors.green,
      buttonsBorderRadius: BorderRadius.circular(30),
      buttonsTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      btnOkOnPress: () => {},
      // Navigator.pop(context),
      dismissOnTouchOutside: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ).show();
  }

  bool _isCopied = false;

  void showErrorMessage(BuildContext context, String error) {
    ToastService.show(context, 'Error: $error');
  }

  void showValidationError(BuildContext context) {
    ToastService.show(context, 'Please fill in all required fields');
  }
}
