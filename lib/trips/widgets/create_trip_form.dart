import 'package:appsagetechwiz/custom_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:appsagetechwiz/custom_widgets/custom_datefield.dart';
import 'package:appsagetechwiz/custom_widgets/custom_text_field.dart';
import 'package:appsagetechwiz/services/auth_service.dart';

class CreateTripForm extends StatefulWidget {
  const CreateTripForm({super.key});

  @override
  State<CreateTripForm> createState() => _CreateTripFormState();
}

class _CreateTripFormState extends State<CreateTripForm> {
  final tripNameController = TextEditingController();
  final destinationController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final budgetController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    tripNameController.dispose();
    destinationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new Trip'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: tripNameController,
                label: 'Trip Name',
                placeholder: 'Trip Name',
                icon: Icons.trip_origin,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: destinationController,
                label: 'Destination',
                placeholder: 'Where to?',
                icon: Icons.place,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomDatefield(
                      placeholder: 'Start Date',
                      dateController: startDateController,
                      validator: _dateValidator,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomDatefield(
                      placeholder: 'End Date',
                      dateController: endDateController,
                      validator: _dateValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: budgetController,
                label: 'Budget',
                placeholder: 'Enter trip budget',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     foregroundColor: Colors.white,
              //     backgroundColor: Theme.of(context).colorScheme.primary,
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              //   onPressed: _submitForm,
              //   child:
              //       const Text('Create Trip', style: TextStyle(fontSize: 16)),
              // ),
              CustomButton(
                onPressed: _submitForm,
                buttonText: 'Create Trip',
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return CustomTextField(
      placeholder: placeholder,
      label: label,
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (keyboardType == TextInputType.number &&
            double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  String? _dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final startDate = DateTime.tryParse(startDateController.text);
        final endDate = DateTime.tryParse(endDateController.text);

        if (startDate == null || endDate == null) {
          throw const FormatException('Invalid date format');
        }

        setState(() {
          _isLoading = true;
        });

        await _authService.addTrip(
          tripName: tripNameController.text,
          destination: destinationController.text,
          startDate: DateTime.parse(startDateController.text),
          endDate: DateTime.parse(endDateController.text),
          budget: double.parse(budgetController.text),
        );

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Created trip successfully')));

        Navigator.pushNamed(context, '/main');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding trip: ${e.toString()}')),
        );
      }
    }
  }
}
