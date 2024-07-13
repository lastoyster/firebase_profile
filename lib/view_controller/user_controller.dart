import 'dart:io';

import '../locator.dart';
import '../models/user_model.dart';
import '../repository/auth_repo.dart';
import '../repository/storage_repo.dart';

class UserController {
  UserModel? _currentUser; // Use nullable type to handle null safety
  final AuthRepo _authRepo = locator.get<AuthRepo>();
  final StorageRepo _storageRepo = locator.get<StorageRepo>();
  late final Future<void> init;

  UserController() {
    init = initUser();
  }

  Future<void> initUser() async {
    try {
      _currentUser = await _authRepo.getUser();
    } catch (e) {
      // Handle the error appropriately
      print('Error initializing user: $e');
    }
  }

  UserModel? get currentUser => _currentUser;

  Future<void> uploadProfilePicture(File image) async {
    if (_currentUser == null) {
      print('User not initialized');
      return;
    }
    try {
      _currentUser!.avatarUrl = await _storageRepo.uploadFile(image);
    } catch (e) {
      // Handle the error appropriately
      print('Error uploading profile picture: $e');
    }
  }

  Future<String?> getDownloadUrl() async {
    if (_currentUser == null) {
      print('User not initialized');
      return null;
    }
    try {
      return await _storageRepo.getUserProfileImage(_currentUser!.uid);
    } catch (e) {
      // Handle the error appropriately
      print('Error getting download URL: $e');
      return null;
    }
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      _currentUser = await _authRepo.signInWithEmailAndPassword(
          email: email, password: password);

      _currentUser!.avatarUrl = (await getDownloadUrl())!;
    } catch (e) {
      // Handle the error appropriately
      print('Error signing in: $e');
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    if (_currentUser == null) {
      print('User not initialized');
      return;
    }
    try {
      _currentUser!.displayName = displayName;
      await _authRepo.updateDisplayName(displayName);
    } catch (e) {
      // Handle the error appropriately
      print('Error updating display name: $e');
    }
  }

  Future<bool> validateCurrentPassword(String password) async {
    try {
      return await _authRepo.validatePassword(password);
    } catch (e) {
      // Handle the error appropriately
      print('Error validating password: $e');
      return false;
    }
  }

  Future<void> updateUserPassword(String password) async {
    try {
      await _authRepo.updatePassword(password);
    } catch (e) {
      // Handle the error appropriately
      print('Error updating password: $e');
    }
  }
}
