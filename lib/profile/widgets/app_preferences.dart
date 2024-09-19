import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../providers/auth_provider.dart';
import '../../utilis/toaster_utils.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_text_field.dart';

class AppPreferencesScreen extends ConsumerStatefulWidget {
  const AppPreferencesScreen({super.key});

  @override
  ConsumerState<AppPreferencesScreen> createState() =>
      _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends ConsumerState<AppPreferencesScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController preferredCurrencyController;
  late TextEditingController averageBudgetController;
  late TextEditingController newPreferenceController;
  late Future<Map<String, dynamic>?> _userDataFuture;
  List<String> travelPreferences = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    preferredCurrencyController = TextEditingController();
    averageBudgetController = TextEditingController();
    newPreferenceController = TextEditingController();

    // Fetch the user data on initialization
    final authService = ref.read(authServiceProvider);
    _userDataFuture = authService.getCurrentUser();
    _userDataFuture.then((userData) {
      if (userData != null) {
        setState(() {
          preferredCurrencyController.text =
              userData['Preferred_Currency'] ?? '';
          averageBudgetController.text =
              userData['Average_Budget'] ?? '';
          travelPreferences =
              List<String>.from(userData['Travel_Preferences'] ?? []);
        });
      }
    });
  }

  // Method to add a new travel preference
  Future<void> _addPreference() async {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(context);

    setState(() {
      travelPreferences.add(newPreferenceController.text.trim());
      newPreferenceController.clear();
    });

    final authService = ref.read(authServiceProvider);
    await authService.addTravelPreference(
      travelPreferences.last,
    );

    ToasterUtils.showCustomSnackBar(context, 'Preference added successfully', isError: false);
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

    ToasterUtils.showCustomSnackBar(context, 'Preference removed successfully', isError: true);
  }

  // Method to update the preferred currency
  Future<void> _updatePreferences() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authService = ref.read(authServiceProvider);
    await authService.updatePreferences(
      preferredCurrencyController.text.trim(),
      averageBudgetController.text.trim()
    );

    setState(() {
      _isLoading = false;
    });

    ToasterUtils.showCustomSnackBar(context, 'Preferences updated successfully',
        isError: false);
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _showAddPreferenceModal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load data'));
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
                    CustomTextField(
                      label: "Average Budget",
                      placeholder: "Enter average budget",
                      controller: averageBudgetController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your average budget';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Location Preferences',
                      style: Theme.of(context).textTheme.headlineSmall,
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

  // Function to show the bottom sheet for adding a new travel preference
  void _showAddPreferenceModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Padding for keyboard
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize
                .min,
            children: [
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
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
