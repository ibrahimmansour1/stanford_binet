import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stanford_binet/core/widgets/custom_loader.dart';

class StudentExamScreen extends StatefulWidget {
  final String sessionCode;

  const StudentExamScreen({super.key, required this.sessionCode});

  @override
  _StudentExamScreenState createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
  int _currentQuestionIndex = 0;
  List<String> _questions = [];
  List<String?> _questionTypes = [];
  List<List<String>?> _options = [];
  List<String?> _answers = [];
  @override
  void initState() {
    super.initState();
    _loadQuestionsFromFirestore();
    _listenForQuestionIndexUpdates();
  }

  Future<void> updateSessionQuestionIds(String sessionId) async {
    try {
      // Fetch all question IDs from the 'questions' collection
      final questionsSnapshot =
          await FirebaseFirestore.instance.collection('questions').get();

      final questionIds = questionsSnapshot.docs.map((doc) => doc.id).toList();

      // Update the session document with the new question IDs
      await FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionId)
          .update({
        'question_ids': questionIds,
      });
    } catch (e) {
      print('Error updating session question IDs: $e');
    }
  }

  void _listenForQuestionIndexUpdates() {
    FirebaseFirestore.instance
        .collection('sessions')
        .doc(widget.sessionCode)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final currentIndex = snapshot.data()?['current_question_index'] as int?;
        if (currentIndex != null && mounted) {
          setState(() {
            _currentQuestionIndex =
                currentIndex.clamp(0, _questions.length - 1);
          });
        }
      }
    });
  }

  Future<void> _loadQuestionsFromFirestore() async {
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
          _questions = questionsSnapshot.docs.map((doc) {
            final data = doc.data();
            return data['question'] as String;
          }).toList();

          _questionTypes = questionsSnapshot.docs.map((doc) {
            final data = doc.data();
            return data['type'] as String?;
          }).toList();

          _options = questionsSnapshot.docs.map((doc) {
            final data = doc.data();
            return (data['options'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList();
          }).toList();
          log(_questions.length.toString());
          _answers = List.filled(_questions.length, null);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading questions: $e')),
      );
    }
  }

  Future<void> _saveAnswer(int index, String answer) async {
    _answers[index] = answer;
    await FirebaseFirestore.instance
        .collection('student_answers')
        .doc('${widget.sessionCode}_$index')
        .set({
      'session_code': widget.sessionCode,
      'question_index': index,
      'answer': answer,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  List<Widget> _buildMultipleChoiceOptions(int index) {
    final options = _options[index];
    if (options == null) return [];

    return options
        .asMap()
        .entries
        .map((entry) => RadioListTile(
              title: Text(entry.value),
              value: entry.value,
              groupValue: _answers[index],
              onChanged: (value) {
                setState(() {
                  _answers[index] = value!;
                  _saveAnswer(index, value);
                });
              },
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam'),
      ),
      body: _questions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CustomLoader(),
                  SizedBox(height: 16),
                  Text('Loading questions...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1}: ${_questions[_currentQuestionIndex]}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  if (_questionTypes[_currentQuestionIndex] ==
                      'multiple_choice') ...[
                    ..._buildMultipleChoiceOptions(_currentQuestionIndex),
                  ] else ...[
                    TextFormField(
                      onChanged: (value) =>
                          _saveAnswer(_currentQuestionIndex, value),
                      decoration: const InputDecoration(
                        labelText: 'Your Answer',
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
