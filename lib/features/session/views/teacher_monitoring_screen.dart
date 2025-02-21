import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stanford_binet/core/widgets/custom_loader.dart';

import '../../../generated/l10n.dart';
import 'widgets/teacher_drawing_view.dart';

class TeacherMonitoringScreen extends StatefulWidget {
  final String sessionCode;

  const TeacherMonitoringScreen({super.key, required this.sessionCode});

  @override
  _TeacherMonitoringScreenState createState() =>
      _TeacherMonitoringScreenState();
}

class _TeacherMonitoringScreenState extends State<TeacherMonitoringScreen> {
  int _currentQuestionIndex = 0;
  List<String> _questions = [];
  Map<int, String?> _studentAnswers = {};
  final Map<int, int> _grades = {}; // Stores the grade for each question
  List<Map<String, dynamic>> _examQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestionsAndMonitorAnswers();
  }

  Future<void> _loadQuestionsAndMonitorAnswers() async {
    try {
      // Load questions from JSON file
      final String jsonString =
          await rootBundle.loadString('assets/json/exams.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      setState(() {
        _examQuestions = jsonData.cast<Map<String, dynamic>>();
        _questions =
            _examQuestions.map((q) => q['question'] as String).toList();
      });

      // Keep listening for student answers as before
      FirebaseFirestore.instance
          .collection('student_answers')
          .where('session_code', isEqualTo: widget.sessionCode)
          .snapshots()
          .listen((snapshot) {
        final answers = <int, String?>{};
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final index = data['question_index'] as int?;
          final answer = data['answer'] as String?;
          if (index != null && answer != null) {
            answers[index] = answer;
          }
        }
        setState(() {
          _studentAnswers = answers;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.of(context).errorLoadingQuestions(e.toString()))),
      );
    }
  }

  Future<void> _updateCurrentQuestionIndex(int newIndex) async {
    await FirebaseFirestore.instance
        .collection('sessions')
        .doc(widget.sessionCode)
        .update({
      'current_question_index': newIndex,
    });
    setState(() {
      _currentQuestionIndex = newIndex;
    });
  }

  Future<void> _saveGrade(int questionIndex, int grade) async {
    try {
      // Query for existing grade document
      final gradeQuery = await FirebaseFirestore.instance
          .collection('grades')
          .where('session_code', isEqualTo: widget.sessionCode)
          .where('question_index', isEqualTo: questionIndex)
          .get();

      if (gradeQuery.docs.isNotEmpty) {
        // Update existing grade
        await gradeQuery.docs.first.reference.update({
          'grade': grade,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new grade if doesn't exist
        await FirebaseFirestore.instance.collection('grades').add({
          'session_code': widget.sessionCode,
          'question_index': questionIndex,
          'grade': grade,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      setState(() {
        _grades[questionIndex] = grade;
      });

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              S.of(context).gradeFeedback(grade == 0
                  ? S.of(context).wrong
                  : grade == 1
                      ? S.of(context).partial
                      : S.of(context).correct),
            ),
            backgroundColor: grade == 2
                ? Colors.green
                : grade == 1
                    ? Colors.orange
                    : Colors.red,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }

      // Show correct answer dialog if grade > 0
      if (grade > 0) {
        final questionId = _questions[questionIndex];
        final questionSnapshot = await FirebaseFirestore.instance
            .collection('questions')
            .doc(questionId)
            .get();

        if (questionSnapshot.exists) {
          final correctAnswer =
              questionSnapshot.data()?['correct_answer'] as String?;
          if (correctAnswer != null && mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(S.of(context).correctAnswer),
                content: Text(S.of(context).correctAnswerIs(correctAnswer)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(S.of(context).ok),
                  ),
                ],
              ),
            );
          }
        }
      }
    } catch (e) {
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).errorSavingGrade(e.toString())),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomLoader(),
              SizedBox(height: 16),
              Text(S.of(context).loadingExamData),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).monitorExam,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProgressIndicator(),
                const SizedBox(height: 32),
                _buildQuestionCard(),
                const SizedBox(height: 24),
                _buildGradeButtons(),
                const SizedBox(height: 24), // Changed from Spacer()
                _buildNavigationButtons(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            S.of(context).questionNumberOf(
                  _currentQuestionIndex + 1,
                  _questions.length,
                ),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final currentQuestion = _examQuestions[_currentQuestionIndex];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).questionLabel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              currentQuestion['question'],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 16),
            if (currentQuestion['question_image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: currentQuestion['type'] == 'drawing'
                    ? TeacherDrawingView(
                        sessionCode: widget.sessionCode,
                        questionIndex: _currentQuestionIndex,
                      )
                    : Image.asset(
                        currentQuestion['question_image'],
                        fit: BoxFit.contain,
                        height: 200,
                      ),
              ),
            const SizedBox(height: 24),
            if (currentQuestion['hint'] != null &&
                currentQuestion['hint'].isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.amber.shade800),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        currentQuestion['hint'],
                        style: TextStyle(color: Colors.amber.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Text(
              S.of(context).studentAnswerLabel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _studentAnswers[_currentQuestionIndex] != null
                  ? currentQuestion['type'] == 'drawing'
                      ? TeacherDrawingView(
                          sessionCode: widget.sessionCode,
                          questionIndex: _currentQuestionIndex,
                        )
                      : Image.asset(
                          'assets/images/${_studentAnswers[_currentQuestionIndex]}',
                          height: 80,
                          width: 80,
                          fit: BoxFit.contain,
                        )
                  : Text(
                      S.of(context).notAnsweredYet,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
            ),
            if (currentQuestion['options'] != null &&
                currentQuestion['option_type'] == 'image')
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).optionsLabel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: (currentQuestion['options'] as List)
                            .asMap()
                            .entries
                            .where((entry) => entry.value != null)
                            .map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: currentQuestion['correct_answer'] ==
                                          entry.key
                                      ? Colors.green
                                      : Colors.grey[300]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                'assets/images/${entry.value}',
                                height: 60,
                                width: 60,
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [0, 1, 2].map((grade) {
        final isSelected = _grades[_currentQuestionIndex] == grade;
        final gradeColor = grade == 2
            ? Colors.green
            : grade == 1
                ? Colors.orange
                : Colors.red;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 105.w,
          height: 105.h,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton(
            onPressed: () => _saveGrade(_currentQuestionIndex, grade),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? gradeColor : Colors.white,
              foregroundColor: isSelected ? Colors.white : gradeColor,
              elevation: isSelected ? 8 : 2,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: gradeColor,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: gradeColor,
                  child: Icon(
                    grade == 2
                        ? Icons.check_rounded
                        : grade == 1
                            ? Icons.remove_rounded
                            : Icons.cancel_rounded,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  grade == 0
                      ? S.of(context).wrong
                      : grade == 1
                          ? S.of(context).partial
                          : S.of(context).correct,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _currentQuestionIndex > 0
                ? () => _updateCurrentQuestionIndex(_currentQuestionIndex - 1)
                : null,
            icon: const Icon(Icons.arrow_back),
            label: Text(S.of(context).previous),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _currentQuestionIndex < _questions.length - 1
                ? () => _updateCurrentQuestionIndex(_currentQuestionIndex + 1)
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: Text(S.of(context).next),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
