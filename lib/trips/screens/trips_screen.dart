import 'package:appsagetechwiz/services/auth_service.dart';
import 'package:appsagetechwiz/trips/widgets/trip_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
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
                      return Column(
                        children: [
                          TripCard(
                            tripId: trip['id'],
                            tripName: trip['Trip_Name'],
                            destination: trip['Destination'],
                            startDate:
                                (trip['Start_Date'] as Timestamp).toDate(),
                            endDate: (trip['End_Date'] as Timestamp).toDate(),
                            budget: trip['Budget'],
                          ),
                          const SizedBox(
                              height: 16), // Add space between each TripCard
                        ],
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-trip');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
