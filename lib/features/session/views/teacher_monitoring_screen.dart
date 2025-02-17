import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _loadQuestionsAndMonitorAnswers();
  }

  Future<void> _loadQuestionsAndMonitorAnswers() async {
    try {
      // Fetch the session document
      final sessionSnapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(widget.sessionCode)
          .get();

      if (sessionSnapshot.exists) {
        final questionIds =
            List<String>.from(sessionSnapshot.data()?['question_ids'] ?? []);

        // Fetch the questions based on their IDs
        final questionsSnapshot = await FirebaseFirestore.instance
            .collection('questions')
            .where(FieldPath.documentId, whereIn: questionIds)
            .get();

        setState(() {
          _questions = questionsSnapshot.docs.map((doc) {
            final data = doc.data();
            return data['question'] as String;
          }).toList();
        });

        // Listen for real-time updates on student answers
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
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading questions: $e')),
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
              'Grade ${grade == 0 ? "Wrong" : grade == 1 ? "Partial" : "Correct"} saved successfully',
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
                title: const Text('Correct Answer'),
                content: Text('The correct answer is: $correctAnswer'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
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
            content: Text('Error saving grade: $e'),
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
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor Exam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}: ${_questions[_currentQuestionIndex]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Student Answer: ${_studentAnswers[_currentQuestionIndex] ?? 'Not answered yet'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [0, 1, 2].map((grade) {
                final isSelected = _grades[_currentQuestionIndex] == grade;
                return Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () => _saveGrade(_currentQuestionIndex, grade),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      foregroundColor:
                          isSelected ? Colors.white : Colors.black87,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$grade',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          grade == 0
                              ? 'Wrong'
                              : grade == 1
                                  ? 'Partial'
                                  : 'Correct',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex > 0
                      ? () =>
                          _updateCurrentQuestionIndex(_currentQuestionIndex - 1)
                      : null,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _currentQuestionIndex < _questions.length - 1
                      ? () =>
                          _updateCurrentQuestionIndex(_currentQuestionIndex + 1)
                      : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
