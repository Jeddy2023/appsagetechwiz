import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ReportDetailscreen extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const ReportDetailscreen({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Report Details',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          GestureDetector(
            onTap: () async {
              await _generateAndSharePdf(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.print,
                      size: 22,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Print',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Trip: ",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    "${reportData['Trip_Name']}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildReportDetailCard(
                context,
                "Destination",
                reportData['Destination'],
                Icons.location_on,
              ),
              _buildReportDetailCard(
                context,
                "Start Date",
                dateFormat.format((reportData['Start_Date'] as Timestamp).toDate()),
                Icons.calendar_today,
              ),
              _buildReportDetailCard(
                context,
                "End Date",
                dateFormat.format((reportData['End_Date'] as Timestamp).toDate()),
                Icons.calendar_today_outlined,
              ),
              _buildReportDetailCard(
                context,
                "Total Budget",
                "\$${reportData['Budget']}",
                Icons.attach_money,
              ),
              _buildReportDetailCard(
                context,
                "Total Expenses",
                "\$${reportData['Total_Expenses']}",
                Icons.money_off,
              ),
              const SizedBox(height: 20),
              Text(
                "Budget vs Expenses",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: LineChart(
                    LineChartData(
                      backgroundColor: Colors.white,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, reportData['Budget']),
                            FlSpot(1, reportData['Total_Expenses']),
                          ],
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 2,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                      titlesData: FlTitlesData(show: true),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: true),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateAndSharePdf(BuildContext context) async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission is required")),
      );
      return;
    }

    final pdf = pw.Document();
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    // Add content to PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Report Details', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text("Trip: ${reportData['Trip_Name']}", style: pw.TextStyle(fontSize: 18)),
            pw.Text("Destination: ${reportData['Destination']}", style: pw.TextStyle(fontSize: 18)),
            pw.Text("Start Date: ${dateFormat.format(reportData['Start_Date'])}", style: pw.TextStyle(fontSize: 18)),
            pw.Text("End Date: ${dateFormat.format(reportData['End_Date'])}", style: pw.TextStyle(fontSize: 18)),
            pw.Text("Total Budget: \$${reportData['Budget']}", style: pw.TextStyle(fontSize: 18)),
            pw.Text("Total Expenses: \$${reportData['Total_Expenses']}", style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 20),
            pw.Text('Thank you for reviewing this report.', style: pw.TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );

    // Save the PDF to a temporary location
    final root = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    final file = File("${root!.path}/report.pdf");
    await file.writeAsBytes(await pdf.save());
    debugPrint('${root.path}/report.pdf');

    final path = file.path;
    await OpenFile.open(path);
  }

  Widget _buildReportDetailCard(BuildContext context, String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE9F0FD),
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                icon,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
