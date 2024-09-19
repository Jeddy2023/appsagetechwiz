import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomAvatar extends StatelessWidget {
  final String profileImageUrl;
  final String? selectedImageUrl;
  final VoidCallback imagePickerHandler;
  final bool isLoading;

  const CustomAvatar({
    super.key,
    this.selectedImageUrl,
    required this.profileImageUrl,
    required this.imagePickerHandler,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            backgroundImage: selectedImageUrl != null
                ? FileImage(File(selectedImageUrl!))
                : Image.network(profileImageUrl).image,
            backgroundColor: const Color.fromRGBO(135, 206, 235, 0.6),
          ),
          if (isLoading) // Show spinner when loading
            Positioned.fill(
              child: Center(
                child: SpinKitCircle(
                  color: Theme.of(context).primaryColor,
                  size: 50.0,
                ),
              ),
            ),
          Positioned(
            right: -40,
            bottom: -25,
            child: SizedBox(
              height: 100,
              width: 100,
              child: TextButton(
                onPressed: imagePickerHandler,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/profile/Icon.svg",
                    height: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
