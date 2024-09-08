import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Sign Up method with additional user information
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Update display name
        await user.updateDisplayName(name);
        await user.reload();

        // Send email verification
        await user.sendEmailVerification();
        return null; // No error, sign-up was successful
      }
    } on FirebaseAuthException catch (e) {
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
      print('User Data Jeddy: ${result.user}');
      return result.user != null ? null : 'Login failed. Please try again.';
    } on FirebaseAuthException catch (e) {
      print('Error that occcured Jeddy: ${e.code}');
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

  // Sign Out method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Password Reset method
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
