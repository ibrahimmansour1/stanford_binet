import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  Future<pw.Font> loadCustomFont() async {
    final fontData = await rootBundle.load('assets/fonts/Tajawal-Regular.ttf');
    return pw.Font.ttf(fontData);
  }

  Future<void> generateSessionReport({
    required String sessionCode,
    required List<Map<String, dynamic>> questions,
    required Map<int, String?> studentAnswers,
    required Map<int, int> grades,
  }) async {
    final pdf = pw.Document();
    final font = await loadCustomFont();

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: font),
        build: (context) => [
          pw.Text('Session Code: $sessionCode',
              style: pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: const [
              'Question',
              'Student Answer',
              'Correct Answer',
              'Grade'
            ],
            data: List<List<String>>.generate(
              questions.length,
              (index) => [
                'Q${index + 1}: ${questions[index]['question']}',
                studentAnswers[index] ?? '',
                questions[index]['correct_answer'] ?? '',
                '${grades[index] ?? 0}',
              ],
            ),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            border: pw.TableBorder.all(),
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/session_report_$sessionCode.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }
}
