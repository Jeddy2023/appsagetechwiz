import 'package:flutter/material.dart';

class SnackBarWidget extends StatefulWidget {
  final String message;
  final bool isError;

  const SnackBarWidget({
    super.key,
    required this.message,
    this.isError = true,
  });

  @override
  State<SnackBarWidget> createState() => _SnackBarWidgetState();
}

class _SnackBarWidgetState extends State<SnackBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 10,
      right: 10,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: widget.isError ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
