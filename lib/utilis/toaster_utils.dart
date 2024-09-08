import 'package:appsagetechwiz/custom_widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

class ToasterUtils {
  static void showCustomSnackBar(BuildContext context, String message, {bool isError = true}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => SnackBarWidget(
        message: message,
        isError: isError,
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove the snack bar after 3 seconds
    Future.delayed(const Duration(seconds: 3)).then((_) => overlayEntry.remove());
  }
}