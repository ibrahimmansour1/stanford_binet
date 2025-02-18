import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'report_summary_row.dart';

class ReportSummaryCard extends StatelessWidget {
  final String sessionCode;
  final int totalQuestions;
  final int answeredQuestions;
  final int totalGrade;
  final int maxPossibleGrade;

  const ReportSummaryCard({
    super.key,
    required this.sessionCode,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.totalGrade,
    required this.maxPossibleGrade,
  });

  @override
  Widget build(BuildContext context) {
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
            ReportSummaryRow(label: 'Session Code:', value: sessionCode),
            ReportSummaryRow(
              label: 'Questions Answered:',
              value: '$answeredQuestions/$totalQuestions',
            ),
            ReportSummaryRow(
              label: 'Total Score:',
              value: '$totalGrade/$maxPossibleGrade',
            ),
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

  Color _getGradeColor(int percentage) {
    if (percentage >= 75) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}
