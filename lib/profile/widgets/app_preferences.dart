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
          averageBudgetController.text = userData['Average_Budget'] ?? '';
          travelPreferences =
              List<String>.from(userData['Travel_Preferences'] ?? []);
        });
      }
    });
  }

  // Method to add a new travel preference
  Future<void> _addPreference() async {
    if (newPreferenceController.text.trim().isEmpty) {
      ToasterUtils.showCustomSnackBar(
          context, 'Please enter a valid preference',
          isError: true);
      return;
    }

    Navigator.pop(context);

    setState(() {
      travelPreferences.add(newPreferenceController.text.trim());
      newPreferenceController.clear();
    });

    final authService = ref.read(authServiceProvider);
    await authService.addTravelPreference(
      travelPreferences.last,
    );

    ToasterUtils.showCustomSnackBar(context, 'Preference added successfully',
        isError: false);
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

    ToasterUtils.showCustomSnackBar(context, 'Preference removed successfully',
        isError: true);
  }

  // Method to update the preferred currency
  Future<void> _updatePreferences() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authService = ref.read(authServiceProvider);
    await authService.updatePreferences(preferredCurrencyController.text.trim(),
        averageBudgetController.text.trim());

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
                    GestureDetector(
                      onTap: showCurrencyOptions,
                      child: AbsorbPointer(
                        child: CustomTextField(
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
                      ),
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
                    if (travelPreferences.isNotEmpty)
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
            mainAxisSize: MainAxisSize.min,
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

  Future showCurrencyOptions() async {
    List<String> getAllCurrencies = [
      "USD - United States Dollar",
      "EUR - Euro",
      "GBP - British Pound",
      "NGN - Nigerian Naira",
      "JPY - Japanese Yen",
      "CAD - Canadian Dollar",
      "AUD - Australian Dollar",
      "INR - Indian Rupee",
      "CNY - Chinese Yuan",
      "BRL - Brazilian Real",
      "MXN - Mexican Peso",
      "RUB - Russian Ruble",
      "ZAR - South African Rand",
      "KRW - South Korean Won",
      "IDR - Indonesian Rupiah",
      "SGD - Singapore Dollar",
      "TRY - Turkish Lira",
      "CHF - Swiss Franc",
      "SEK - Swedish Krona",
      "NZD - New Zealand Dollar",
      "PLN - Polish Zloty",
      "THB - Thai Baht",
      "DKK - Danish Krone",
      "NOK - Norwegian Krone",
      "HKD - Hong Kong Dollar",
      "SGD - Singapore Dollar",
      "MYR - Malaysian Ringgit",
      "PHP - Philippine Peso",
      "IDR - Indonesian Rupiah",
      "VND - Vietnamese Dong",
      "PKR - Pakistani Rupee",
      "EGP - Egyptian Pound",
      "MAD - Moroccan Dirham",
      "AED - United Arab Emirates Dirham",
      "ILS - Israeli Shekel",
      "SAR - Saudi Riyal",
      "QAR - Qatari Riyal",
      "KWD - Kuwaiti Dinar",
      "OMR - Omani Rial",
      "BHD - Bahraini Dinar",
      "NZD - New Zealand Dollar",
      "TWD - New Taiwan Dollar",
      "CLP - Chilean Peso",
      "COP - Colombian Peso",
      "PEN - Peruvian Sol",
      "DZD - Algerian Dinar",
      "IQD - Iraqi Dinar",
      "JOD - Jordanian Dinar",
      "LBP - Lebanese Pound",
      "LYD - Libyan Dinar",
      "TND - Tunisian Dinar",
      "AFN - Afghan Afghani",
      "BAM - Bosnian Convertible Mark",
      "BGN - Bulgarian Lev",
      "HRK - Croatian Kuna",
      "CZK - Czech Koruna",
      "HUF - Hungarian Forint",
      "ISK - Icelandic Krona",
      "RON - Romanian Leu",
      "RSD - Serbian Dinar",
      "UAH - Ukrainian Hryvnia",
      "XAF - Central African CFA Franc",
      "XOF - West African CFA Franc",
      "KES - Kenyan Shilling",
      "TZS - Tanzanian Shilling",
      "UGX - Ugandan Shilling",
      "GHS - Ghanaian Cedi",
      "XPF - CFP Franc",
      "MUR - Mauritian Rupee",
      "NPR - Nepalese Rupee",
      "BWP - Botswana Pula",
      "SZL - Swazi Lilangeni",
      "LKR - Sri Lankan Rupee",
      "MVR - Maldivian Rufiyaa",
      "KZT - Kazakhstani Tenge",
      "UZS - Uzbekistani Som",
      "AMD - Armenian Dram",
      "GEL - Georgian Lari",
      "BYN - Belarusian Ruble",
      "MNT - Mongolian Tugrik",
      "MMK - Myanmar Kyat",
      "BDT - Bangladeshi Taka",
      "LAK - Lao Kip",
      "KHR - Cambodian Riel",
      "ETB - Ethiopian Birr",
      "SDG - Sudanese Pound",
      "SOS - Somali Shilling",
      "ZMW - Zambian Kwacha",
      "MWK - Malawian Kwacha",
      "BND - Brunei Dollar",
      "KYD - Cayman Islands Dollar",
      "BZD - Belize Dollar",
      "TTD - Trinidad and Tobago Dollar",
      "FJD - Fijian Dollar",
      "PGK - Papua New Guinean Kina",
      "SBD - Solomon Islands Dollar",
      "TOP - Tongan Paʻanga",
      "VUV - Vanuatu Vatu",
      "NAD - Namibian Dollar",
      "BBD - Barbadian Dollar",
      "BSD - Bahamian Dollar",
      "JMD - Jamaican Dollar",
      "HTG - Haitian Gourde",
      "GYD - Guyanese Dollar",
    ];

    // A controller for the search field
    TextEditingController searchController = TextEditingController();

    // This list will hold the filtered currencies
    List<String> filteredCurrencies = List.from(getAllCurrencies);

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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search bar
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search Currency',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredCurrencies = getAllCurrencies
                              .where((currency) => currency
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: filteredCurrencies.map((String currency) {
                            return ListTile(
                              title: Text(currency),
                              onTap: () {
                                setState(() {
                                  // Split the currency string to extract the 3-letter code
                                  preferredCurrencyController.text =
                                      currency.split(' ')[0];
                                });
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        ),
                      ),
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
