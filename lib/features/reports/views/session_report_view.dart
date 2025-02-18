import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
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

  Future<pw.Font> loadCustomFont() async {
    final fontData = await rootBundle.load('assets/fonts/Tajawal-Regular.ttf');
    return pw.Font.ttf(fontData);
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    // Load a custom font
    final font = await loadCustomFont();

    // Add a page to the PDF with the custom font
    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: font),
        build: (context) => [
          pw.Text('Session Code: ${widget.sessionCode}',
              style: pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: const [
              'Question',
              'Student Answer',
              'Correct Answer',
              'Grade'
            ],
            data: List<List<String>>.generate(
              questions.length,
              (index) => [
                'Q${index + 1}: ${questions[index]['question']}',
                studentAnswers[index] ?? '',
                questions[index]['correct_answer'] ?? '',
                '${grades[index] ?? 0}',
              ],
            ),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            border: pw.TableBorder.all(),
          ),
        ],
      ),
    );

    // Save the PDF to a file
    final output = await getTemporaryDirectory();
    final file =
        File('${output.path}/session_report_${widget.sessionCode}.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the PDF
    OpenFile.open(file.path);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generatePdf,
            tooltip: 'Generate PDF',
          ),
        ],
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
