import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  // Private constructor for Singleton pattern
  AuthService._privateConstructor();

  // Static instance of AuthService
  static final AuthService _instance = AuthService._privateConstructor();

  // Factory constructor to return the same instance
  factory AuthService() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Helper function to hash passwords using SHA256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Sign Up method with additional user information
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Extract first and last names from the full name
        List<String> nameParts = name.split(' ');
        String firstName = nameParts.first;
        String lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        // Hash the password
        String passwordHash = _hashPassword(password);

        // Save user data in Firestore 'Users' collection
        await _firestore.collection('Users').doc(user.uid).set({
          'User_Id': user.uid,
          'Email': email,
          'Password_Hash': passwordHash,
          'First_Name': firstName,
          'Last_Name': lastName,
          'Profile_Picture':
              'https://res.cloudinary.com/dn7xnr4ll/image/upload/v1722866767/notionistsNeutral-1722866616198_iu61hw.png',
        });

        // Update display name
        await user.updateDisplayName(name);
        await user.updatePhotoURL(
            'https://res.cloudinary.com/dn7xnr4ll/image/upload/v1722866767/notionistsNeutral-1722866616198_iu61hw.png');
        await user.reload();

        // Send email verification
        await user.sendEmailVerification();
        return null; // No error, sign-up was successful
      }
    } on FirebaseAuthException catch (e) {
      print('Error here jeddy error: $e');
      switch (e.code) {
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'network-request-failed':
          return 'Network error occurred. Please check your connection.';
        default:
          return 'An unknown error occurred. Please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
    return 'Sign up failed. Please try again.';
  }

  // Sign In method
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user != null ? null : 'Login failed. Please try again.';
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          return 'Invalid email or password .';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'The password is incorrect. Please try again.';
        default:
          return 'An error occurred. Please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Google Sign-In method
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return 'Google sign-in aborted.';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('Users').doc(user.uid).set({
            'User_Id': user.uid,
            'Email': user.email,
            'First_Name': user.displayName?.split(' ').first ?? '',
            'Last_Name': user.displayName!.split(' ').length > 1
                ? user.displayName?.split(' ').sublist(1).join(' ')
                : '',
            'Profile_Picture': user.photoURL,
            'signInMethod': 'google',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return user != null ? null : 'Google sign-in failed. Please try again.';
    } catch (e) {
      return 'An error occurred during Google sign-in. Please try again.';
    }
  }

  // Method to get the current logged-in user and their Firestore data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      // Get the current user from Firebase Authentication
      User? user = _auth.currentUser;

      if (user != null) {
        // Fetch user data from Firestore based on the user ID
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(user.uid).get();

        if (userDoc.exists) {
          // Combine both FirebaseAuth user data and Firestore user data
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          // Add FirebaseAuth-specific data (if needed)
          userData['emailVerified'] = user.emailVerified;
          userData['displayName'] = user.displayName;
          userData['photoURL'] = user.photoURL;
          userData['creationTime'] =
              user.metadata.creationTime?.toIso8601String();
          userData['lastSignInTime'] =
              user.metadata.lastSignInTime?.toIso8601String();

          return userData;
        } else {
          return null; // No user data found in Firestore
        }
      } else {
        return null; // No user is currently logged in
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null; // Handle error appropriately in your app
    }
  }

  // Method to update user email, first name, and last name
  Future<String?> updateUserInfo({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Update email in Firebase Authentication
        await user.verifyBeforeUpdateEmail(email);

        // Update display name (full name)
        String displayName = '$firstName $lastName';
        await user.updateDisplayName(displayName);

        // Update the user info in Firestore
        await _firestore.collection('Users').doc(user.uid).update({
          'First_Name': firstName,
          'Last_Name': lastName,
          'Email': email,
        });

        await user.reload();

        return null; // Update successful
      } else {
        return 'No user is currently logged in.';
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email is already in use by another account.';
        case 'requires-recent-login':
          return 'Please reauthenticate and try again.';
        case 'invalid-email':
          return 'The provided email is invalid.';
        default:
          return 'An error occurred. Please try again.';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign Out method
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Password Reset method
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
