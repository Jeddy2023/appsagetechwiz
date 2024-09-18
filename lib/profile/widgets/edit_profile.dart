import 'dart:io';

import 'package:appsagetechwiz/custom_widgets/custom_button.dart';
import 'package:appsagetechwiz/custom_widgets/custom_text_field.dart';
import 'package:appsagetechwiz/profile/widgets/custom_avatar.dart';
import 'package:appsagetechwiz/utilis/image_utils.dart';
import 'package:appsagetechwiz/utilis/toaster_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  late Future<Map<String, dynamic>?> _userDataFuture;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  Map<String, dynamic>? _userData;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();

    // Fetch the current user data when the screen initializes
    final authService = ref.read(authServiceProvider);
    _userDataFuture = authService.getCurrentUser();

    _userDataFuture.then((userData) {
      if (userData != null) {
        setState(() {
          _userData = userData;
          firstNameController.text = userData['First_Name'] ?? '';
          lastNameController.text = userData['Last_Name'] ?? '';
          emailController.text = userData['Email'] ?? '';
        });
      }
    });
  }

  /// Method to handle image selection
  Future<void> _handleImageSelection() async {
    try {
      final image = await ImageUtils.showOptions(context);
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _isLoading = true;
        });

        final authService = ref.read(authServiceProvider);
        final errorMessage = await authService.updateUserProfilePicture(imageFile: _selectedImage!);

        setState(() {
          _isLoading = false;
        });

        if (errorMessage == null) {
          // Optionally, update local user data or show a success message
          ToasterUtils.showCustomSnackBar(context, 'Profile picture updated successfully');
        } else {
          // Show error message if update failed
          ToasterUtils.showCustomSnackBar(context, errorMessage);
        }
      }
    } catch (error) {
      setState(() {
        _isLoading = false; // Hide loader on error
      });
      ToasterUtils.showCustomSnackBar(context, 'An error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomAvatar(
                  profileImageUrl: _userData?['photoURL'] ??
                      'https://res.cloudinary.com/dn7xnr4ll/image/upload/v1722866767/notionistsNeutral-1722866616198_iu61hw.png',
                  imagePickerHandler: _handleImageSelection,
                  selectedImageUrl: _selectedImage?.path,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  placeholder: "First name",
                  label: "First name",
                  controller: firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                    size: 21,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  placeholder: "Last name",
                  label: "Last name",
                  controller: lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                    size: 21,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  placeholder: "Email",
                  label: "Email",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(
                    Icons.alternate_email,
                    color: Colors.grey,
                    size: 21,
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {},
                  buttonText: "Save Changes",
                  isLoading: _isLoading,
                ),
              ],
            )),
      ),
    );
  }
}
