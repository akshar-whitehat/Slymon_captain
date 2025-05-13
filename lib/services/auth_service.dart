// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/captain_model.dart';

// Mock User class to simulate Firebase User
class MockUser {
  final String uid;
  final String email;
  String? displayName;
  String? photoURL;

  MockUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
  });

  Future<void> updateDisplayName(String? name) async {
    displayName = name;
  }

  Future<void> updatePhotoURL(String? url) async {
    photoURL = url;
  }

  Future<void> delete() async {
    // Mock implementation
  }
}

class AuthService extends ChangeNotifier {
  // Mock user for authentication
  MockUser? _currentUser;
  
  // Mock captain data
  CaptainModel? _mockCaptain;
  
  // Authentication state
  bool _isAuthenticated = false;
  
  // Mock user getter
  MockUser? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  
  // Mock auth state changes stream
  Stream<MockUser?> get authStateChanges => 
      Stream.fromFuture(Future.value(_currentUser));
  
  // Constructor with mock data
  AuthService() {
    // Initialize with mock data for demo
    _initializeMockData();
  }
  
  void _initializeMockData() {
    // Create a mock vehicle
    final vehicle = VehicleModel(
      id: 'vehicle-001',
      number: 'KA-01-AB-1234',
      model: 'Honda City',
      type: VehicleType.car,
      registrationUrl: '',
      isVerified: true,
    );
    
    // Create a mock captain
    _mockCaptain = CaptainModel(
      id: 'captain-001',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '9876543210',
      photoUrl: '',
      walletBalance: 5000.0,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now(),
      drivingLicenseUrl: '',
      isVerified: true,
      isOnline: true,
      rating: 4.7,
      totalRides: 128,
      totalEarnings: 25600.0,
      vehicle: vehicle,
      currentLatitude: 12.9716,
      currentLongitude: 77.5946,
    );
  }
  
  // Sign in with email and password
  Future<MockUser> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo, accept any email/password with basic validation
      if (email.isEmpty || !email.contains('@') || password.isEmpty || password.length < 6) {
        throw Exception('Invalid email or password');
      }
      
      // Create a mock user
      _currentUser = MockUser(
        uid: 'captain-001',
        email: email,
        displayName: _mockCaptain?.name,
        photoURL: _mockCaptain?.photoUrl,
      );
      
      // Update authentication state
      _isAuthenticated = true;
      
      // Update online status in mock captain
      if (_mockCaptain != null) {
        _mockCaptain = _mockCaptain!.copyWith(isOnline: true);
      }
      
      notifyListeners();
      return _currentUser!;
    } catch (e) {
      rethrow;
    }
  }
  
  // Register with email and password
  Future<MockUser> registerWithEmailAndPassword(
    String email, 
    String password, 
    String name, 
    String phone,
    VehicleModel vehicle,
    String drivingLicenseUrl,
    String photoUrl,
  ) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo, accept any valid input
      if (email.isEmpty || !email.contains('@') || password.isEmpty || password.length < 6) {
        throw Exception('Invalid email or password');
      }
      
      // Create a mock user
      _currentUser = MockUser(
        uid: 'captain-002',
        email: email,
        displayName: name,
        photoURL: photoUrl,
      );
      
      // Create a mock captain
      _mockCaptain = CaptainModel(
        id: _currentUser!.uid,
        name: name,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
        walletBalance: 0.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        drivingLicenseUrl: drivingLicenseUrl,
        isVerified: false,
        isOnline: true,
        rating: 0.0,
        totalRides: 0,
        totalEarnings: 0.0,
        vehicle: vehicle,
        currentLatitude: 0.0,
        currentLongitude: 0.0,
      );
      
      // Update authentication state
      _isAuthenticated = true;
      
      notifyListeners();
      return _currentUser!;
    } catch (e) {
      rethrow;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Update online status in mock captain
      if (_mockCaptain != null) {
        _mockCaptain = _mockCaptain!.copyWith(isOnline: false);
      }
      
      // Clear current user
      _currentUser = null;
      
      // Update authentication state
      _isAuthenticated = false;
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo, just validate email
      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Invalid email');
      }
      
      // In a real app, this would send a password reset email
      print('Password reset email sent to $email');
    } catch (e) {
      rethrow;
    }
  }
  
  // Get captain data
  Future<CaptainModel?> getCaptainData() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return mock captain data
      return _mockCaptain;
    } catch (e) {
      rethrow;
    }
  }
  
  // Update captain profile
  Future<void> updateCaptainProfile(CaptainModel captain) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Update mock captain
      _mockCaptain = captain;
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Update captain location
  Future<void> updateCaptainLocation(double latitude, double longitude) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Update mock captain location
      if (_mockCaptain != null) {
        _mockCaptain = _mockCaptain!.copyWith(
          currentLatitude: latitude,
          currentLongitude: longitude,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Update online status
  Future<void> updateOnlineStatus(bool isOnline) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Update mock captain online status
      if (_mockCaptain != null) {
        _mockCaptain = _mockCaptain!.copyWith(isOnline: isOnline);
      }
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Delete account
  Future<void> deleteAccount() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Clear mock captain and user
      _mockCaptain = null;
      _currentUser = null;
      
      // Update authentication state
      _isAuthenticated = false;
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}