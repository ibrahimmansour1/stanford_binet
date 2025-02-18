import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import 'report_answer_row.dart';

class ReportQuestionCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> questionData;
  final String studentAnswer;
  final int grade;

  const ReportQuestionCard({
    super.key,
    required this.index,
    required this.questionData,
    required this.studentAnswer,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
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
                _buildQuestionBadge(context),
                SizedBox(width: 8.w),
                _buildGradeBadge(context),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              questionData['question'],
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12.h),
            ReportAnswerRow(
              label: 'Correct Answer:',
              value: questionData['correct_answer'],
            ),
            ReportAnswerRow(
              label: 'Student Answer:',
              value: studentAnswer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionBadge(BuildContext context) {
    return Container(
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
    );
  }

  Widget _buildGradeBadge(BuildContext context) {
    return Container(
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
    );
  }

  Color _getGradeColor(int percentage) {
    if (percentage >= 75) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}
