import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/delete_session_service.dart';
import '../services/pdf_service.dart';
import '../services/session_service.dart';
import 'widgets/report_loading_state.dart';
import 'widgets/report_question_card.dart';
import 'widgets/report_summary_card.dart';

class SessionReportView extends StatefulWidget {
  final String sessionCode;
  const SessionReportView({super.key, required this.sessionCode});

  @override
  State<SessionReportView> createState() => _SessionReportViewState();
}

class _SessionReportViewState extends State<SessionReportView> {
  final _sessionService = SessionService();
  final _pdfService = PdfService();
  final _deleteService = DeleteSessionService();
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
      final data = await _sessionService.loadSessionData(widget.sessionCode);

      setState(() {
        questions = data['questions'];
        studentAnswers = data['studentAnswers'];
        grades = data['grades'];
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading session data: $e')),
      );
    }
  }

  Future<void> _generatePdf() async {
    await _pdfService.generateSessionReport(
      sessionCode: widget.sessionCode,
      questions: questions,
      studentAnswers: studentAnswers,
      grades: grades,
    );
  }

  Future<void> _deleteReport() async {
    try {
      final confirmed = await _deleteService.showDeleteConfirmation(context);

      if (confirmed ?? false) {
        if (!mounted) return;
        _deleteService.showLoadingDialog(context);

        await _deleteService.deleteSession(widget.sessionCode);

        if (!mounted) return;
        Navigator.pop(context); // Close loading dialog
        Navigator.pop(context); // Return to reports list

        _deleteService.showSuccessMessage(context);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _deleteService.showErrorMessage(context, e.toString());
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
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generatePdf,
            tooltip: 'Generate PDF',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteReport,
            tooltip: 'Delete Report',
            color: Colors.red,
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: questions.isEmpty
          ? const ReportLoadingState()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReportSummaryCard(
                      sessionCode: widget.sessionCode,
                      totalQuestions: questions.length,
                      answeredQuestions: studentAnswers.length,
                      totalGrade: grades.values
                          .fold<int>(0, (sum, grade) => sum + grade),
                      maxPossibleGrade: questions.length * 2,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Detailed Results',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    ...List.generate(
                      questions.length,
                      (index) => ReportQuestionCard(
                        index: index,
                        questionData: questions[index],
                        studentAnswer: studentAnswers[index] ?? 'Not answered',
                        grade: grades[index] ?? 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
