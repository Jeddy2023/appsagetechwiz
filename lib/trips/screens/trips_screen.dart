import 'package:appsagetechwiz/services/auth_service.dart';
import 'package:appsagetechwiz/trips/widgets/trip_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  final AuthService _authService = AuthService();
  List<Object?> _trips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    setState(() => _isLoading = true);
    _trips = await _authService.fetchTrips();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Trips',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: Container(),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _trips.isEmpty
              ? const Center(child: Text('No trips found. Add a new trip!'))
              : Padding(
                  padding: const EdgeInsets.only(top: 30, left: 13, right: 13),
                  child: ListView.builder(
                    itemCount: _trips.length,
                    itemBuilder: (context, index) {
                      final trip = _trips[index] as Map<String, dynamic>;
                      return TripCard(
                          tripName: trip['Trip_Name'],
                          destination: trip['Destination'],
                          startDate: (trip['Start_Date'] as Timestamp).toDate(),
                          endDate: (trip['End_Date'] as Timestamp).toDate(),
                          budget: trip['Budget']);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTripModalBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
    return 'Invalid Date';
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false}) {
    return TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.surface, // Border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .surface, // Border color when focused
          ),
        ),
        hintText: label,
        prefixIcon: Icon(icon),
      ),
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  Widget _buildDateField(BuildContext context, TextEditingController controller,
      String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.surface, // Border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .surface, // Border color when focused
          ),
        ),
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                dialogBackgroundColor: Colors.transparent,
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          controller.text = _formatDate(date);
        }
      },
    );
  }

  bool _validateInputs(
      TextEditingController tripName,
      TextEditingController destination,
      TextEditingController startDate,
      TextEditingController endDate,
      TextEditingController budget) {
    if (tripName.text.isEmpty ||
        destination.text.isEmpty ||
        startDate.text.isEmpty ||
        endDate.text.isEmpty ||
        budget.text.isEmpty) {
      return false;
    }
    return true;
  }

  void _showAddTripModalBottomSheet(BuildContext context) {
    final tripNameController = TextEditingController();
    final destinationController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final budgetController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Create New Trip',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    const SizedBox(height: 24),
                    _buildTextField(
                        tripNameController, 'Trip Name', Icons.trip_origin),
                    const SizedBox(height: 16),
                    _buildTextField(
                        destinationController, 'Destination', Icons.place),
                    const SizedBox(height: 16),
                    _buildDateField(context, startDateController, 'Start Date',
                        Icons.calendar_today),
                    const SizedBox(height: 16),
                    _buildDateField(
                        context, endDateController, 'End Date', Icons.event),
                    const SizedBox(height: 16),
                    _buildTextField(
                        budgetController, 'Budget', Icons.attach_money,
                        isNumber: true),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            if (_validateInputs(
                                tripNameController,
                                destinationController,
                                startDateController,
                                endDateController,
                                budgetController)) {
                              await _authService.addTrip(
                                tripName: tripNameController.text,
                                destination: destinationController.text,
                                startDate:
                                    DateTime.parse(startDateController.text),
                                endDate: DateTime.parse(endDateController.text),
                                budget: double.parse(budgetController.text),
                              );
                              Navigator.of(context).pop();
                              _loadTrips();
                            }
                          },
                          child: const Text('Add Trip'),
                        ),
                      ],
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
