import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'student_exam_screen.dart';

class StudentExamEntryScreen extends StatefulWidget {
  const StudentExamEntryScreen({super.key});

  @override
  _StudentExamEntryScreenState createState() => _StudentExamEntryScreenState();
}

class _StudentExamEntryScreenState extends State<StudentExamEntryScreen> {
  final TextEditingController _sessionCodeController = TextEditingController();
  String? _errorMessage;

  Future<void> _validateSessionCode(BuildContext context) async {
    final sessionCode = _sessionCodeController.text.trim();
    if (sessionCode.isEmpty || sessionCode.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a valid 6-digit session code.';
      });
      return;
    }

    try {
      // Check if the session code exists in Firestore
      final sessionSnapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .where('session_code', isEqualTo: sessionCode)
          .limit(1)
          .get();

      if (sessionSnapshot.docs.isEmpty) {
        setState(() {
          _errorMessage = 'Invalid session code. Please try again.';
        });
        return;
      }

      // Navigate to the exam screen if the session code is valid
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentExamScreen(sessionCode: sessionCode),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error validating session code. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Session Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _sessionCodeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Session Code',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _validateSessionCode(context),
              child: const Text('Start Exam'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
