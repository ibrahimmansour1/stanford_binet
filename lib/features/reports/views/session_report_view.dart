import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

class SessionReportView extends StatefulWidget {
  final String sessionCode;
  const SessionReportView({super.key, required this.sessionCode});

  @override
  State<SessionReportView> createState() => _SessionReportViewState();
}

class _SessionReportViewState extends State<SessionReportView> {
  List<Map<String, dynamic>> questions = [];
  Map<int, String?> studentAnswers = {};
  Map<int, int> grades = {};

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    try {
      final sessionSnapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(widget.sessionCode)
          .get();
      if (sessionSnapshot.exists) {
        final questionIds =
            List<String>.from(sessionSnapshot.data()?['question_ids'] ?? []);
        final questionsSnapshot = await FirebaseFirestore.instance
            .collection('questions')
            .where(FieldPath.documentId, whereIn: questionIds)
            .get();
        setState(() {
          questions = questionsSnapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'question': data['question'],
              'correct_answer': data['correct_answer'],
            };
          }).toList();
        });
        final answersSnapshot = await FirebaseFirestore.instance
            .collection('student_answers')
            .where('session_code', isEqualTo: widget.sessionCode)
            .get();
        final answers = <int, String?>{};
        for (final doc in answersSnapshot.docs) {
          final data = doc.data();
          final index = data['question_index'] as int?;
          final answer = data['answer'] as String?;
          if (index != null && answer != null) {
            answers[index] = answer;
          }
        }
        setState(() {
          studentAnswers = answers;
        });
        final gradesSnapshot = await FirebaseFirestore.instance
            .collection('grades')
            .where('session_code', isEqualTo: widget.sessionCode)
            .get();
        final grades = <int, int>{};
        for (final doc in gradesSnapshot.docs) {
          final data = doc.data();
          final index = data['question_index'] as int?;
          final grade = data['grade'] as int?;
          if (index != null && grade != null) {
            grades[index] = grade;
          }
        }
        setState(() {
          this.grades = grades;
        });
      }
    } catch (e) {
      log('Error loading session data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading session data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Session Report',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: questions.isEmpty
          ? _buildLoadingState()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(),
                    SizedBox(height: 24.h),
                    _buildQuestionsList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 16.h),
          Text(
            'Loading session data...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalQuestions = questions.length;
    final answeredQuestions = studentAnswers.length;
    final totalGrade = grades.values.fold<int>(0, (sum, grade) => sum + grade);
    final maxPossibleGrade = questions.length * 2;
    final percentage = (totalGrade / maxPossibleGrade * 100).round();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16.h),
            _buildSummaryRow('Session Code:', widget.sessionCode),
            _buildSummaryRow(
                'Questions Answered:', '$answeredQuestions/$totalQuestions'),
            _buildSummaryRow('Total Score:', '$totalGrade/$maxPossibleGrade'),
            SizedBox(height: 16.h),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              color: _getGradeColor(percentage),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            SizedBox(height: 8.h),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _getGradeColor(percentage),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Results',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16.h),
        ...List.generate(
          questions.length,
          (index) => _buildQuestionCard(index),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(int index) {
    final questionData = questions[index];
    final studentAnswer = studentAnswers[index] ?? 'Not answered';
    final grade = grades[index] ?? 0;

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Q${index + 1}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getGradeColor(grade * 50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Grade: $grade/2',
                    style: TextStyle(
                      color: _getGradeColor(grade * 50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              questionData['question'],
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12.h),
            _buildAnswerRow('Correct Answer:', questionData['correct_answer']),
            _buildAnswerRow('Student Answer:', studentAnswer),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getGradeColor(int percentage) {
    if (percentage >= 75) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}
