import 'dart:html' as html;
import 'dart:typed_data';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

Future<void> exportDynamicExcel({
  required List<String> headers,
  required List<List<dynamic>> dataRows,
  String fileName = 'exported_data.xlsx',
}) async {
  final workbook = xlsio.Workbook();
  final sheet = workbook.worksheets[0];

  // Ghi header
  for (int i = 0; i < headers.length; i++) {
    final cell = sheet.getRangeByIndex(1, i + 1);
    cell.setText(headers[i]);

    // Style header
    final style = cell.cellStyle;
    style.bold = true;
    style.backColor = '#D9D9D9';
    style.hAlign = xlsio.HAlignType.center;
    style.borders.all.lineStyle = xlsio.LineStyle.thin;
  }

  // Ghi dữ liệu
  for (int rowIndex = 0; rowIndex < dataRows.length; rowIndex++) {
    final row = dataRows[rowIndex];
    for (int colIndex = 0; colIndex < row.length; colIndex++) {
      final cell = sheet.getRangeByIndex(rowIndex + 2, colIndex + 1);
      cell.setText('${row[colIndex] ?? ""}');

      // Style cell data
      cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
    }
  }

  // Auto-fit tất cả các cột
  for (int i = 1; i <= headers.length; i++) {
    sheet.autoFitColumn(i);
  }

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final blob = html.Blob([Uint8List.fromList(bytes)],
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
}
