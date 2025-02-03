import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../data/models/vehicle.dart';
import '../../data/models/driver.dart';
import '../../data/models/fuel_transaction.dart';

class PdfService {
  Future<void> generateFuelReport({
    required List<FuelTransaction> transactions,
    required Vehicle vehicle,
    required Driver driver,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Fuel Transaction Report'),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  'Date',
                  'Amount (L)',
                  'Cost',
                  'Station',
                  'Status',
                ].map((header) => pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(header, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                )).toList(),
              ),
              ...transactions.map(
                (transaction) => pw.TableRow(
                  children: [
                    DateFormat('dd/MM/yyyy').format(transaction.timestamp),
                    transaction.amount.toStringAsFixed(2),
                    transaction.cost.toStringAsFixed(2),
                    transaction.stationName,
                    transaction.status,
                  ].map((cell) => pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(cell.toString()),
                  )).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'fuel_report.pdf');
  }

  Future<void> generateVehicleReport({
    required List<Vehicle> vehicles,
    required List<Driver> drivers,
  }) async {
    final pdf = pw.Document();

    final vehicleRows = [
      pw.TableRow(
        children: [
          'Plate Number',
          'Status',
          'Fuel Level',
          'Last Maintenance',
          'Status',
        ].map((header) => pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(header, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        )).toList(),
      ),
      ...vehicles.map(
        (vehicle) => pw.TableRow(
          children: [
            vehicle.plateNumber,
            vehicle.status,
            '${(vehicle.currentFuelLevel / vehicle.fuelCapacity * 100).toStringAsFixed(1)}%',
            vehicle.lastMaintenance != null 
              ? DateFormat('dd/MM/yyyy').format(vehicle.lastMaintenance!)
              : 'No maintenance record',
            vehicle.status,
          ].map((cell) => pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(cell.toString()),
          )).toList(),
        ),
      ),
    ];

    final driverRows = [
      pw.TableRow(
        children: [
          'Name',
          'Status',
          'License Expiry',
          'Assigned Vehicles',
          'Status',
        ].map((header) => pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(header, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        )).toList(),
      ),
      ...drivers.map(
        (driver) => pw.TableRow(
          children: [
            driver.name,
            driver.status,
            driver.licenseExpiryDate != null 
              ? DateFormat('dd/MM/yyyy').format(driver.licenseExpiryDate!)
              : 'No expiry date',
            driver.assignedVehicleIds?.join(', ') ?? 'None',
            driver.status,
          ].map((cell) => pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(cell.toString()),
          )).toList(),
        ),
      ),
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Fleet Status Report'),
          ),
          pw.SizedBox(height: 20),
          pw.Header(
            level: 1,
            child: pw.Text('Vehicle Status'),
          ),
          pw.Table(
            border: pw.TableBorder.all(),
            children: vehicleRows,
          ),
          pw.SizedBox(height: 20),
          pw.Header(
            level: 1,
            child: pw.Text('Driver Status'),
          ),
          pw.Table(
            border: pw.TableBorder.all(),
            children: driverRows,
          ),
        ],
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'fleet_report.pdf');
  }
}
