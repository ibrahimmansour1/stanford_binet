import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherDrawingView extends StatelessWidget {
  final String sessionCode;
  final int questionIndex;
  final String imagePath; // Add this

  const TeacherDrawingView({
    super.key,
    required this.sessionCode,
    required this.questionIndex,
    required this.imagePath, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('student_answers')
          .doc('${sessionCode}_$questionIndex')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        final strokes = _parseStrokes(snapshot.data!['answer']);
        return imagePath.isNotEmpty
            ? DrawingPreview(imagePath: imagePath, strokes: strokes)
            : Text('No background image available');
      },
    );
  }

  List<List<Offset>> _parseStrokes(dynamic data) {
    if (data is! String) return [];
    try {
      final List strokesData = jsonDecode(data);
      print('Parsed ${strokesData.length} strokes'); // Debug log
      return strokesData
          .map<List<Offset>>((stroke) => stroke.map<Offset>((point) {
                return Offset((point['x'] as num).toDouble(),
                    (point['y'] as num).toDouble());
              }).toList())
          .toList();
    } catch (e) {
      print('Error parsing strokes: $e');
      return [];
    }
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
    return SizedBox(
      height: 300, // Fixed container height
      child: LayoutBuilder(
        builder: (context, constraints) {
          print('Canvas size: ${constraints.biggest}'); // Debug log
          return Stack(
            alignment: Alignment.center, // Center the content
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.contain,
                width: constraints.maxWidth, // Use available width
              ),
              CustomPaint(
                size: constraints.biggest, // Fill available space
                painter: _StrokePainter(
                  strokes: strokes,
                  size: constraints.biggest,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Size size;

  _StrokePainter({required this.strokes, required this.size});

  @override
  void paint(Canvas canvas, Size _) {
    print('Painting ${strokes.length} strokes'); // Debug log
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (final stroke in strokes) {
      print('Stroke with ${stroke.length} points'); // Debug log
      for (int i = 0; i < stroke.length - 1; i++) {
        final start =
            Offset(stroke[i].dx * size.width, stroke[i].dy * size.height);
        final end = Offset(
            stroke[i + 1].dx * size.width, stroke[i + 1].dy * size.height);
        print('Drawing line from $start to $end'); // Debug log
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_StrokePainter old) => old.strokes != strokes;
}
