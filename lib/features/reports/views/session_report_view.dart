import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    if (questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Report'),
      ),
      body: DataTable(
          columns: [
            DataColumn(label: const Text('Question')),
            DataColumn(label: const Text('Correct Answer')),
            DataColumn(label: const Text('Student Answer')),
            DataColumn(label: const Text('Grade')),
          ],
          rows: List.generate(questions.length, (index) {
            final questionNumber = (index + 1).toString();
            final correctAnswer = questions[index]['correct_answer'];
            final studentAnswer = studentAnswers[index] ?? '';
            final grade = grades[index] ?? 0;
            return DataRow(cells: [
              DataCell(Text(questionNumber)),
              DataCell(Text(correctAnswer)),
              DataCell(Text(studentAnswer)),
              DataCell(Text(grade.toString())),
            ]);
          })),
    );
  }
}
