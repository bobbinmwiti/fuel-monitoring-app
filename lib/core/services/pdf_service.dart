import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  Future<void> generateFuelReport({
    required List<Map<String, dynamic>> fuelRecords,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Fuel Consumption Report'),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Period: ${startDate.toString().substring(0, 10)} to ${endDate.toString().substring(0, 10)}',
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: <String>['Date', 'Amount', 'Cost', 'Mileage'],
                data: fuelRecords.map(
                  (record) => [
                    record['date'].toString().substring(0, 10),
                    '${record['amount']} L',
                    '\$${record['cost']}',
                    '${record['mileage']} km',
                  ],
                ).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'fuel_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }
}
