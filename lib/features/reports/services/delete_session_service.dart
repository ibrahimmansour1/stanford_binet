import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_loader.dart';

class DeleteSessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool?> showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text(
          'Are you sure you want to delete this report? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CustomLoader(),
    );
  }

  void showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Report deleted successfully'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showErrorMessage(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Error deleting report: $error'),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
