import 'package:appsagetechwiz/reports/screens/report_detailscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../providers/auth_provider.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  bool _isLoading = true;

  List<Map<String, dynamic>> reports = [];

  Future<void> _fetchReports() async {
    final authService = ref.read(authServiceProvider);
    setState(() => _isLoading = true);

    List<Map<String, dynamic>> _reports = await authService.fetchAllReports();

    setState(() {
      reports = _reports;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          'Reports',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/generate-report');
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
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.generating_tokens_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Generate',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(), // Show loader when loading
                )
              : reports.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 64,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No recent reports',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return Card(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            title: Text(
                              report['Trip_Name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            tileColor: Colors.white,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Destination: ${report['Destination']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(color: Colors.black45),
                                ),
                                Text(
                                  "Created on: ${dateFormat.format((report['Report_Creation_Date'] as Timestamp).toDate())}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(color: Colors.black45),
                                ),
                              ],
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9F0FD),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                Icons.label_important_outline,
                                size: 22,
                                color: Colors.black45,
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReportDetailscreen(reportData: report, backAction: _fetchReports,),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
