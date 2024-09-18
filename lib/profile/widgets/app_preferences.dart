import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../providers/auth_provider.dart';
import '../../utilis/toaster_utils.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';

class AppPreferencesScreen extends ConsumerStatefulWidget {
  const AppPreferencesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AppPreferencesScreen> createState() => _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends ConsumerState<AppPreferencesScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController preferredCurrencyController;
  late TextEditingController newPreferenceController;
  late Future<Map<String, dynamic>?> _userDataFuture;
  List<String> travelPreferences = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    preferredCurrencyController = TextEditingController();
    newPreferenceController = TextEditingController();

    // Fetch the user data on initialization
    final authService = ref.read(authServiceProvider);
    _userDataFuture = authService.getCurrentUser();
    _userDataFuture.then((userData) {
      if (userData != null) {
        setState(() {
          preferredCurrencyController.text = userData['Preferred_Currency'] ?? '';
          travelPreferences = List<String>.from(userData['Travel_Preferences'] ?? []);
        });
      }
    });
  }

  // Method to add a new travel preference
  Future<void> _addPreference() async {
    if (newPreferenceController.text.trim().isEmpty) return;

    setState(() {
      travelPreferences.add(newPreferenceController.text.trim());
      newPreferenceController.clear();
    });

    final authService = ref.read(authServiceProvider);
    await authService.addTravelPreference(
      travelPreferences.last,
    );
  }

  // Method to remove a travel preference
  Future<void> _removePreference(String preference) async {
    setState(() {
      travelPreferences.remove(preference);
    });

    final authService = ref.read(authServiceProvider);
    await authService.deleteTravelPreference(
      preference,
    );
  }

  // Method to update the preferred currency
  Future<void> _updatePreferences() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authService = ref.read(authServiceProvider);
    await authService.updatePreferredCurrency(
      preferredCurrencyController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    ToasterUtils.showCustomSnackBar(context, 'Preferences updated successfully', isError: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Edit Preferences',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Failed to load data'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: "Preferred Currency",
                      placeholder: "Enter preferred currency",
                      controller: preferredCurrencyController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your preferred currency';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Travel Preferences',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: travelPreferences.length,
                      itemBuilder: (context, index) {
                        final preference = travelPreferences[index];
                        return ListTile(
                          title: Text(preference),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removePreference(preference),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Add New Travel Preference",
                      placeholder: "Enter a country",
                      controller: newPreferenceController,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: _addPreference,
                      buttonText: "Add Preference",
                      isLoading: _isLoading,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: _updatePreferences,
                      buttonText: "Save Changes",
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
