import 'package:appsagetechwiz/custom_widgets/custom_button.dart';
import 'package:appsagetechwiz/custom_widgets/custom_text_field.dart';
import 'package:appsagetechwiz/reports/screens/report_detailscreen.dart';
import 'package:appsagetechwiz/services/auth_service.dart';
import 'package:flutter/material.dart';

class GenerateReportScreen extends StatefulWidget {
  const GenerateReportScreen({super.key});

  @override
  State<GenerateReportScreen> createState() => _GenerateReportScreenState();
}

class _GenerateReportScreenState extends State<GenerateReportScreen> {
  late TextEditingController tripController;
  final AuthService _authService = AuthService();
  String? selectedTrip;
  List<Map<String, dynamic>> trips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    tripController = TextEditingController();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    setState(() => _isLoading = true);
    final fetchedTrips = await _authService.fetchTrips();
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
                        onPressed: () {
                          if(selectedTrip != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportDetailscreen(
                                  reportData: selectedTripDetails!,
                                ),
                              ),
                            );
                          }
                          return;
                        }, // Disable the button when no trip is selected
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
