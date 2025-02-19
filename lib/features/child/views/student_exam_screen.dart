import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:stanford_binet/core/widgets/custom_loader.dart';

import '../../../generated/l10n.dart';

class Question {
  final int id;
  final int quizId;
  final String type;
  final String question;
  final String questionImage;
  final List<String?> options;
  final String optionType;
  final int correctAnswer;
  final int maxGrade;
  final String hint;

  Question({
    required this.id,
    required this.quizId,
    required this.type,
    required this.question,
    required this.questionImage,
    required this.options,
    required this.optionType,
    required this.correctAnswer,
    required this.maxGrade,
    required this.hint,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      quizId: json['quiz_id'],
      type: json['type'],
      question: json['question'],
      questionImage: json['question_image'],
      options: List<String?>.from(json['options']),
      optionType: json['option_type'],
      correctAnswer: json['correct_answer'],
      maxGrade: json['max_grade'],
      hint: json['hint'],
    );
  }
}

class StudentExamScreen extends StatefulWidget {
  final String sessionCode;

  const StudentExamScreen({super.key, required this.sessionCode});

  @override
  _StudentExamScreenState createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
  int _currentQuestionIndex = 0;
  List<Question> _questions = [];
  List<String?> _answers = [];

  @override
  void initState() {
    super.initState();
    _loadQuestionsFromJson();
    _listenForQuestionIndexUpdates();
  }

  Future<void> _loadQuestionsFromJson() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/json/exams.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      setState(() {
        _questions = jsonList.map((json) => Question.fromJson(json)).toList();
        _answers = List.filled(_questions.length, null);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(S.of(context).errorLoadingQuestions(e.toString()))),
        );
      }
    }
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

  Future<void> _saveAnswer(int index, String answer) async {
    try {
      setState(() {
        _answers[index] = answer;
      });

      // Create a document reference
      final docRef = FirebaseFirestore.instance
          .collection('student_answers')
          .doc('${widget.sessionCode}_$index');

      // Save the answer
      await docRef.set({
        'session_code': widget.sessionCode,
        'question_index': index,
        'answer': answer,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Answer saved successfully'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving answer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error saving answer: $e'); // For debugging
    }
  }

  Widget _buildOptionImage(String? imagePath) {
    if (imagePath == null) return const SizedBox.shrink();
    return Image.asset(
      'assets/images/$imagePath',
      height: 80,
      width: 80,
      fit: BoxFit.contain,
    );
  }

  List<Widget> _buildMultipleChoiceOptions(Question question) {
    return question.options.asMap().entries.map((entry) {
      if (entry.value == null) return const SizedBox.shrink();

      return InkWell(
        onTap: () => _saveAnswer(_currentQuestionIndex, entry.value!),
        child: Card(
          color: _answers[_currentQuestionIndex] == entry.value
              ? Colors.blue.withOpacity(0.3)
              : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildOptionImage(entry.value),
          ),
        ),
      );
    }).toList();
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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _questions[_currentQuestionIndex].question,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    if (_questions[_currentQuestionIndex]
                        .questionImage
                        .isNotEmpty)
                      Image.asset(
                        _questions[_currentQuestionIndex].questionImage,
                        fit: BoxFit.contain,
                      ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _buildMultipleChoiceOptions(
                          _questions[_currentQuestionIndex]),
                    ),
                    if (_questions[_currentQuestionIndex].hint.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Hint: ${_questions[_currentQuestionIndex].hint}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
