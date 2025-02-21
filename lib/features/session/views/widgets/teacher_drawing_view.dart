import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherDrawingView extends StatelessWidget {
  final String sessionCode;
  final int questionIndex;

  const TeacherDrawingView({
    super.key,
    required this.sessionCode,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('student_answers')
          .doc('${sessionCode}_$questionIndex')
          .snapshots(),
      builder: (context, snapshot) {
        final strokes = _parseStrokes(snapshot.data?['answer']);
        return DrawingPreview(
          imagePath: 'assets/images/exam_one/1.png',
          strokes: strokes,
        );
      },
    );
  }

  List<List<Offset>> _parseStrokes(dynamic data) {
    if (data is! String) return [];
    final List strokesData = jsonDecode(data);
    return strokesData
        .map<List<Offset>>((stroke) => stroke.map<Offset>((point) {
              return Offset(point['x'], point['y']);
            }).toList())
        .toList();
  }
}

class DrawingPreview extends StatelessWidget {
  final String imagePath;
  final List<List<Offset>> strokes;

  const DrawingPreview({
    super.key,
    required this.imagePath,
    required this.strokes,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Image.asset(imagePath, fit: BoxFit.contain),
            CustomPaint(
              painter:
                  _StrokePainter(strokes: strokes, size: constraints.biggest),
            ),
          ],
        );
      },
    );
  }
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Size size;

  _StrokePainter({required this.strokes, required this.size});

  @override
  void paint(Canvas canvas, Size _) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(
          Offset(stroke[i].dx * size.width, stroke[i].dy * size.height),
          Offset(stroke[i + 1].dx * size.width, stroke[i + 1].dy * size.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_StrokePainter old) => old.strokes != strokes;
}
