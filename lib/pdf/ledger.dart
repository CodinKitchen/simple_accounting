import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:simple_accouting/database/models/operation.dart';

Future<Uint8List> generateLedger(List<Operation> operations) {
  final pdf = pw.Document();

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      footer: _buildFooter,
      build: (pw.Context context) {
        return [_contentTable(context, operations)];
      }));

  return pdf.save();
}

pw.Widget _contentTable(pw.Context context, List<Operation> operations) {
  const tableHeaders = [
    'Date',
    'Label',
    'Montant',
  ];

  return pw.Table.fromTextArray(
    border: null,
    cellAlignment: pw.Alignment.centerLeft,
    headerDecoration: const pw.BoxDecoration(
      color: PdfColors.blueAccent200,
    ),
    headerHeight: 25,
    cellHeight: 40,
    cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.centerLeft,
      2: pw.Alignment.centerRight,
    },
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(
      color: PdfColors.grey700,
      fontSize: 10,
    ),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: PdfColors.black,
          width: .5,
        ),
      ),
    ),
    headers: List<String>.generate(
      tableHeaders.length,
      (col) => tableHeaders[col],
    ),
    data: List<List<String>>.generate(
      operations.length,
      (row) => [
        DateFormat('yyyy-MM-dd').format(operations[row].date ?? DateTime.now()),
        operations[row].account?.name ?? 'Divers',
        operations[row].amount?.toString() ?? '0',
      ],
    ),
  );
}

pw.Widget _buildFooter(pw.Context context) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Container(),
      pw.Text(
        'Page ${context.pageNumber}/${context.pagesCount}',
        style: const pw.TextStyle(
          fontSize: 10,
          color: PdfColors.black,
        ),
        textAlign: pw.TextAlign.right,
      ),
    ],
  );
}
