import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String placeholder;
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    required this.placeholder,
    required this.label,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.controller,
            cursorColor: Colors.grey.shade800,
            keyboardType: widget.keyboardType,
            onTapOutside: (e) {
              FocusScope.of(context).unfocus();
            },
            validator: widget.validator,
            obscureText: widget.isPassword ? _obscureText : false,  // Only obscure text if it's a password field
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? IconButton(
                onPressed: _toggleObscureText,
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,  // Toggle icons correctly
                  color: Colors.grey,
                ),
              )
                  : null,  // No visibility toggle for non-password fields
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              filled: true,
              hintText: widget.placeholder,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade800,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
