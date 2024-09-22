import 'package:appsagetechwiz/custom_widgets/custom_button.dart';
import 'package:appsagetechwiz/custom_widgets/custom_text_field.dart';
import 'package:appsagetechwiz/reports/screens/report_detailscreen.dart';
import 'package:appsagetechwiz/services/auth_service.dart';
import 'package:appsagetechwiz/utilis/toaster_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class GenerateReportScreen extends ConsumerStatefulWidget {
  const GenerateReportScreen({super.key});

  @override
  ConsumerState<GenerateReportScreen> createState() => _GenerateReportScreenState();
}

class _GenerateReportScreenState extends ConsumerState<GenerateReportScreen> {
  late TextEditingController tripController;
  final AuthService _authService = AuthService();
  String? selectedTrip;
  String? selectedTripId;
  List<Map<String, dynamic>> trips = [];
  bool _isLoading = true;
  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    super.initState();
    tripController = TextEditingController();
    _fetchTrips();
  }

  Future<void> _fetchReports() async {
    final authService = ref.read(authServiceProvider);
    setState(() => _isLoading = true);

    List<Map<String, dynamic>> _reports = await authService.fetchAllReports();

    setState(() {
      reports = _reports;
      _isLoading = false;
    });
  }

  Future<void> _fetchTrips() async {
    setState(() => _isLoading = true);
    final fetchedTrips = await _authService.fetchTrips();
    print('$fetchedTrips');
    setState(() {
      trips = fetchedTrips.cast<Map<String, dynamic>>();
      _isLoading = false;
    });
  }

  Map<String, dynamic>? selectedTripDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Generate New Report',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : trips.isEmpty
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
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: showTripOptions,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            label: "Preferred Currency",
                            placeholder: "Enter preferred currency",
                            controller: tripController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your preferred currency';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        onPressed: () async {
                          if (selectedTrip != null) {
                            // Navigate to the ReportDetailscreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportDetailscreen(
                                  reportData: selectedTripDetails!,
                                  backAction: _fetchReports,
                                ),
                              ),
                            );

                            // Show a loading toast or overlay
                            ToasterUtils.showCustomSnackBar(context, 'Generating report...', isError: false);

                            try {
                              // Attempt to generate the report
                              String? result = await _authService.generateReport(selectedTripId!);

                              // Check for success or error
                              if (result == null) {
                                ToasterUtils.showCustomSnackBar(context, 'Report generated successfully', isError: false);
                              } else {
                                ToasterUtils.showCustomSnackBar(context, result, isError: false);
                              }
                            } catch (e) {
                              // Handle any unexpected errors
                              ToasterUtils.showCustomSnackBar(context, 'Failed to generate report: $e', isError: true);
                            }
                          } else {
                            ToasterUtils.showCustomSnackBar(context, 'Please select a trip', isError: true);
                          }
                        },
                        buttonText: "Generate Report",
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
    );
  }

  Future showTripOptions() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  // Set mainAxisSize to min to allow the column to shrink to fit its content
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // No Expanded here, we want the content to shrink-wrap
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: trips.length,
                      itemBuilder: (context, index) {
                        final trip = trips[index];
                        return ListTile(
                          title: Text(trip['Trip_Name'] ?? 'Unnamed Trip'),
                          onTap: () {
                            setState(() {
                              selectedTrip = trip['Trip_Name'] ?? 'Unnamed Trip';
                              selectedTripId = trip['Trip_Id'] ?? trip['id'];
                              selectedTripDetails = trip;
                              tripController.text = selectedTrip!;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
