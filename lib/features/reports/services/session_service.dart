import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> loadSessionData(String sessionCode) async {
    try {
      final sessionSnapshot =
          await _firestore.collection('sessions').doc(sessionCode).get();

      if (!sessionSnapshot.exists) {
        throw Exception('Session not found');
      }

      final questionIds =
          List<String>.from(sessionSnapshot.data()?['question_ids'] ?? []);

      final questionsSnapshot = await _firestore
          .collection('questions')
          .where(FieldPath.documentId, whereIn: questionIds)
          .get();

      final questions = questionsSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'question': data['question'],
          'correct_answer': data['correct_answer'],
        };
      }).toList();

      final answersSnapshot = await _firestore
          .collection('student_answers')
          .where('session_code', isEqualTo: sessionCode)
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

      final gradesSnapshot = await _firestore
          .collection('grades')
          .where('session_code', isEqualTo: sessionCode)
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

      return {
        'questions': questions,
        'studentAnswers': answers,
        'grades': grades,
      };
    } catch (e) {
      log('Error loading session data: $e');
      rethrow;
    }
  }

  Future<void> deleteSession(String sessionCode) async {
    final batch = _firestore.batch();

    // Delete answers
    final answersSnapshot = await _firestore
        .collection('student_answers')
        .where('session_code', isEqualTo: sessionCode)
        .get();
    for (var doc in answersSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Delete grades
    final gradesSnapshot = await _firestore
        .collection('grades')
        .where('session_code', isEqualTo: sessionCode)
        .get();
    for (var doc in gradesSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Delete session
    batch.delete(_firestore.collection('sessions').doc(sessionCode));

    // Commit the batch
    await batch.commit();
  }
}
