import 'package:flutter/material.dart';

class DrawingCanvas extends StatefulWidget {
  final String imagePath;
  final Function(List<List<Map<String, double>>>) onDrawingUpdate;

  const DrawingCanvas({
    super.key,
    required this.imagePath,
    required this.onDrawingUpdate,
  });

  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset> _currentStroke = [];
  final List<List<Offset>> _strokes = [];
  Size _canvasSize = Size.zero;
  final _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = 4.0
    ..strokeCap = StrokeCap.round;

  List<List<Map<String, double>>> _normalizeStrokes() {
    return _strokes
        .map((stroke) => stroke.map((point) {
              return {
                'x': point.dx / _canvasSize.width,
                'y': point.dy / _canvasSize.height,
              };
            }).toList())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          children: [
            Image.asset(widget.imagePath, fit: BoxFit.contain),
            GestureDetector(
              onPanStart: (details) {
                final box = context.findRenderObject() as RenderBox;
                _currentStroke = [box.globalToLocal(details.globalPosition)];
              },
              onPanUpdate: (details) {
                final box = context.findRenderObject() as RenderBox;
                setState(() {
                  _currentStroke.add(box.globalToLocal(details.globalPosition));
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _strokes.add(List.from(_currentStroke));
                  _currentStroke.clear();
                  widget.onDrawingUpdate(_normalizeStrokes());
                });
              },
              child: CustomPaint(
                painter: _DrawingPainter(
                  strokes: _strokes,
                  currentStroke: _currentStroke,
                  painting: _paint,
                ),
                size: _canvasSize,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Paint painting;

  _DrawingPainter({
    required this.strokes,
    required this.currentStroke,
    required this.painting,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], painting);
      }
    }
    for (int i = 0; i < currentStroke.length - 1; i++) {
      canvas.drawLine(currentStroke[i], currentStroke[i + 1], painting);
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) =>
      oldDelegate.strokes != strokes ||
      oldDelegate.currentStroke != currentStroke;
}
