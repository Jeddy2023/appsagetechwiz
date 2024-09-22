import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatefield extends StatefulWidget {
  final TextEditingController dateController;
  final String placeholder;
  final String? Function(String?)? validator;

  const CustomDatefield(
      {super.key,
      required this.dateController,
      this.validator,
      required this.placeholder});

  @override
  State<CustomDatefield> createState() => _CustomDatefieldState();
}

class _CustomDatefieldState extends State<CustomDatefield> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.placeholder,
        prefixIcon: Icon(
          Icons.calendar_today,
          color: Theme.of(context).colorScheme.primary,
        ),
        border: InputBorder.none,
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
      ),
      readOnly: true,
      validator: widget.validator,
      onTap: () => _selectDate(context),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
