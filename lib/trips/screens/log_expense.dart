import 'package:appsagetechwiz/custom_widgets/custom_button.dart';
import 'package:appsagetechwiz/custom_widgets/custom_text_field.dart';
import 'package:appsagetechwiz/services/auth_service.dart';
import 'package:flutter/material.dart';

class LogExpensePage extends StatefulWidget {
  final String tripId;

  const LogExpensePage({super.key, required this.tripId});

  @override
  State<LogExpensePage> createState() => _LogExpensePageState();
}

class _LogExpensePageState extends State<LogExpensePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final AuthService authService = AuthService();
  DateTime? selectedDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _addExpense() async {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _categoryController.text.isEmpty ||
        _notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await authService.addExpense(
          tripId: widget.tripId,
          title: _titleController.text,
          amount: double.parse(_amountController.text),
          category: _categoryController.text,
          notes: _notesController.text,
          date: DateTime.now());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully!')),
      );
      Navigator.pushNamed(context, '/main');
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding expense: $e')),
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String placeholder, IconData icon,
      {bool isNumber = false}) {
    return CustomTextField(
      placeholder: placeholder,
      label: label,
      controller: controller,
      prefixIcon: Icon(icon),
      keyboardType:
          isNumber == true ? TextInputType.number : TextInputType.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log New Expense'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(
                  _titleController, 'Title', 'Trip title', Icons.title),
              const SizedBox(height: 16),
              _buildTextField(_amountController, 'Amount', 'Amount spent',
                  Icons.attach_money,
                  isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(_categoryController, 'Category',
                  'Expense Category', Icons.category),
              const SizedBox(height: 16),
              _buildTextField(
                  _notesController, 'Notes', 'Leave a note', Icons.note),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                    isLoading: _isSubmitting,
                    onPressed: _addExpense,
                    buttonText: 'Log Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
