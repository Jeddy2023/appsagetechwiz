import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPField extends StatefulWidget {
  final int length;
  final void Function(String) onCompleted;
  const OTPField({
    super.key,
    required this.length,
    required this.onCompleted,
  });
  @override
  State<OTPField> createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers =
        List.generate(widget.length, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double boxWidth =
            (constraints.maxWidth - (widget.length - 1) * 16) / widget.length;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            widget.length,
            (index) => Padding(
              padding:
                  EdgeInsets.only(right: index < widget.length - 1 ? 16.0 : 0),
              child: SizedBox(
                width: boxWidth,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (index < widget.length - 1) {
                        _focusNodes[index + 1].requestFocus();
                      } else {
                        _focusNodes[index].unfocus();
                        String otp = _controllers
                            .map((controller) => controller.text)
                            .join();
                        widget.onCompleted(otp);
                      }
                    } else if (value.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
