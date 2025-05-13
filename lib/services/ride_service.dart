// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/ride_model.dart';
import '../services/auth_service.dart';

class RideService extends ChangeNotifier {
  // Reference to the mock auth service
  final AuthService? _authService;
  
  // Mock rides data
  List<RideModel> _mockRides = [];
  
  // Mock user ID
  final String _mockCaptainId = 'captain-001';
  
  // Constructor
  RideService({AuthService? authService}) : _authService = authService {
    // Initialize with mock data
    _initializeMockData();
  }
  
  void _initializeMockData() {
    final now = DateTime.now();
    
    // Create mock locations
    final locations = [
      LocationModel(
        id: 'loc-001',
        name: 'Indiranagar',
        address: 'Indiranagar, Bengaluru, Karnataka',
        latitude: 12.9784,
        longitude: 77.6408,
      ),
      LocationModel(
        id: 'loc-002',
        name: 'Koramangala',
        address: 'Koramangala, Bengaluru, Karnataka',
        latitude: 12.9279,
        longitude: 77.6271,
      ),
      LocationModel(
        id: 'loc-003',
        name: 'Whitefield',
        address: 'Whitefield, Bengaluru, Karnataka',
        latitude: 12.9698,
        longitude: 77.7499,
      ),
      LocationModel(
        id: 'loc-004',
        name: 'Electronic City',
        address: 'Electronic City, Bengaluru, Karnataka',
        latitude: 12.8399,
        longitude: 77.6770,
      ),
      LocationModel(
        id: 'loc-005',
        name: 'MG Road',
        address: 'MG Road, Bengaluru, Karnataka',
        latitude: 12.9757,
        longitude: 77.6096,
      ),
      LocationModel(
        id: 'loc-006',
        name: 'Hebbal',
        address: 'Hebbal, Bengaluru, Karnataka',
        latitude: 13.0358,
        longitude: 77.5970,
      ),
      LocationModel(
        id: 'loc-007',
        name: 'HSR Layout',
        address: 'HSR Layout, Bengaluru, Karnataka',
        latitude: 12.9116,
        longitude: 77.6741,
      ),
      LocationModel(
        id: 'loc-008',
        name: 'Marathahalli',
        address: 'Marathahalli, Bengaluru, Karnataka',
        latitude: 12.9591,
        longitude: 77.6974,
      ),
      LocationModel(
        id: 'loc-009',
        name: 'Kempegowda International Airport',
        address: 'Kempegowda International Airport, Bengaluru, Karnataka',
        latitude: 13.1986,
        longitude: 77.7066,
      ),
      LocationModel(
        id: 'loc-010',
        name: 'Bannerghatta',
        address: 'Bannerghatta, Bengaluru, Karnataka',
        latitude: 12.8002,
        longitude: 77.5775,
      ),
    ];
    
    // Create mock bids
    final bids = [
      BidModel(
        id: 'bid-001',
        captainId: _mockCaptainId,
        rideId: 'ride-001',
        amount: 350.0,
        note: 'I can pick up in 5 minutes',
        createdAt: now.subtract(const Duration(minutes: 30)),
        status: BidStatus.pending,
      ),
      BidModel(
        id: 'bid-002',
        captainId: 'captain-002',
        rideId: 'ride-001',
        amount: 380.0,
        createdAt: now.subtract(const Duration(minutes: 25)),
        status: BidStatus.pending,
      ),
      BidModel(
        id: 'bid-003',
        captainId: 'captain-003',
        rideId: 'ride-001',
        amount: 400.0,
        note: 'Premium service with water bottles',
        createdAt: now.subtract(const Duration(minutes: 20)),
        status: BidStatus.pending,
      ),
      BidModel(
        id: 'bid-004',
        captainId: _mockCaptainId,
        rideId: 'ride-002',
        amount: 420.0,
        createdAt: now.subtract(const Duration(hours: 1)),
        status: BidStatus.accepted,
      ),
    ];
    
    // Create mock rides
    _mockRides = [
      // Available rides (pending)
      RideModel(
        id: 'ride-001',
        userId: 'user-001',
        pickup: locations[0], // Indiranagar
        dropoff: locations[1], // Koramangala
        scheduledTime: now.add(const Duration(minutes: 30)),
        estimatedFare: 350.0,
        estimatedDuration: 25,
        estimatedDistance: 5.2,
        status: RideStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 45)),
        bids: [bids[0], bids[1], bids[2]],
      ),
      RideModel(
        id: 'ride-005',
        userId: 'user-003',
        pickup: locations[4], // MG Road
        dropoff: locations[5], // Hebbal
        scheduledTime: now.add(const Duration(hours: 1)),
        estimatedFare: 320.0,
        estimatedDuration: 35,
        estimatedDistance: 8.7,
        status: RideStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 20)),
        bids: [],
      ),
      RideModel(
        id: 'ride-006',
        userId: 'user-004',
        pickup: locations[6], // HSR Layout
        dropoff: locations[7], // Marathahalli
        scheduledTime: now.add(const Duration(hours: 2)),
        estimatedFare: 280.0,
        estimatedDuration: 30,
        estimatedDistance: 7.5,
        status: RideStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 15)),
        bids: [],
      ),
      
      // Active rides
      RideModel(
        id: 'ride-002',
        userId: 'user-002',
        captainId: _mockCaptainId,
        pickup: locations[2], // Whitefield
        dropoff: locations[3], // Electronic City
        scheduledTime: now.add(const Duration(minutes: 15)),
        estimatedFare: 420.0,
        estimatedDuration: 45,
        estimatedDistance: 18.3,
        status: RideStatus.accepted,
        createdAt: now.subtract(const Duration(hours: 2)),
        acceptedAt: now.subtract(const Duration(minutes: 45)),
        bids: [bids[3]],
        selectedBidId: bids[3].id,
      ),
      
      // Completed rides
      RideModel(
        id: 'ride-003',
        userId: 'user-003',
        captainId: _mockCaptainId,
        pickup: locations[8], // Airport
        dropoff: locations[4], // MG Road
        scheduledTime: now.subtract(const Duration(days: 1, hours: 2)),
        estimatedFare: 850.0,
        estimatedDuration: 60,
        estimatedDistance: 35.2,
        status: RideStatus.completed,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
        acceptedAt: now.subtract(const Duration(days: 1, hours: 2, minutes: 45)),
        completedAt: now.subtract(const Duration(days: 1, hours: 1)),
        actualFare: 900.0,
        bids: [],
        userRating: 4.5,
        userFeedback: 'Great passenger, very punctual',
      ),
      RideModel(
        id: 'ride-007',
        userId: 'user-005',
        captainId: _mockCaptainId,
        pickup: locations[0], // Indiranagar
        dropoff: locations[9], // Bannerghatta
        scheduledTime: now.subtract(const Duration(days: 2, hours: 5)),
        estimatedFare: 450.0,
        estimatedDuration: 50,
        estimatedDistance: 15.8,
        status: RideStatus.completed,
        createdAt: now.subtract(const Duration(days: 2, hours: 6)),
        acceptedAt: now.subtract(const Duration(days: 2, hours: 5, minutes: 30)),
        completedAt: now.subtract(const Duration(days: 2, hours: 4)),
        actualFare: 480.0,
        bids: [],
        userRating: 5.0,
        userFeedback: 'Excellent passenger',
      ),
      
      // Cancelled rides
      RideModel(
        id: 'ride-004',
        userId: 'user-004',
        captainId: _mockCaptainId,
        pickup: locations[6], // HSR Layout
        dropoff: locations[7], // Marathahalli
        scheduledTime: now.subtract(const Duration(days: 3, hours: 1)),
        estimatedFare: 280.0,
        estimatedDuration: 30,
        estimatedDistance: 7.5,
        status: RideStatus.cancelled,
        createdAt: now.subtract(const Duration(days: 3, hours: 2)),
        acceptedAt: now.subtract(const Duration(days: 3, hours: 1, minutes: 45)),
        cancelledAt: now.subtract(const Duration(days: 3, hours: 1, minutes: 15)),
        cancelReason: 'Passenger requested cancellation',
        bids: [],
      ),
    ];
  }
  
  // Get available rides
  Stream<List<RideModel>> getAvailableRides() {
    // Simulate a stream of available rides
    return Stream.value(_mockRides)
        .asyncMap((rides) async {
          // Simulate network delay
          await Future.delayed(const Duration(milliseconds: 800));
          return rides.where((ride) => ride.status == RideStatus.pending).toList();
        });
  }
  
  // Get captain's active rides
  Stream<List<RideModel>> getCaptainActiveRides() {
    // Simulate a stream of active rides
    return Stream.value(_mockRides)
        .asyncMap((rides) async {
          // Simulate network delay
          await Future.delayed(const Duration(milliseconds: 800));
          return rides.where((ride) => 
              ride.captainId == _mockCaptainId && 
              (ride.status == RideStatus.accepted || 
               ride.status == RideStatus.arriving || 
               ride.status == RideStatus.arrived || 
               ride.status == RideStatus.inProgress)
          ).toList();
        });
  }
  
  // Get captain's completed rides
  Stream<List<RideModel>> getCaptainCompletedRides() {
    // Simulate a stream of completed rides
    return Stream.value(_mockRides)
        .asyncMap((rides) async {
          // Simulate network delay
          await Future.delayed(const Duration(milliseconds: 800));
          return rides.where((ride) => 
              ride.captainId == _mockCaptainId && 
              ride.status == RideStatus.completed
          ).toList();
        });
  }
  
  // Get captain's cancelled rides
  Stream<List<RideModel>> getCaptainCancelledRides() {
    // Simulate a stream of cancelled rides
    return Stream.value(_mockRides)
        .asyncMap((rides) async {
          // Simulate network delay
          await Future.delayed(const Duration(milliseconds: 800));
          return rides.where((ride) => 
              ride.captainId == _mockCaptainId && 
              ride.status == RideStatus.cancelled
          ).toList();
        });
  }
  
  // Get ride by ID
  Future<RideModel?> getRideById(String rideId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Find ride by ID
      return _mockRides.firstWhere((ride) => ride.id == rideId);
    } catch (e) {
      return null;
    }
  }
  
  // Place bid
  Future<void> placeBid(String rideId, double amount, String? note) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Find ride by ID
      final rideIndex = _mockRides.indexWhere((ride) => ride.id == rideId);
      
      if (rideIndex == -1) {
        throw Exception('Ride not found');
      }
      
      final ride = _mockRides[rideIndex];
      
      // Check if captain already placed a bid
      final bidIndex = ride.bids.indexWhere((bid) => bid.captainId == _mockCaptainId);
      
      if (bidIndex != -1) {
        // Update existing bid
        final updatedBids = [...ride.bids];
        updatedBids[bidIndex] = BidModel(
          id: ride.bids[bidIndex].id,
          captainId: _mockCaptainId,
          rideId: rideId,
          amount: amount,
          note: note,
          createdAt: DateTime.now(),
          status: BidStatus.pending,
        );
        
        // Update ride with new bids
        _mockRides[rideIndex] = ride.copyWith(bids: updatedBids);
      } else {
        // Add new bid
        final newBid = BidModel(
          id: 'bid-${DateTime.now().millisecondsSinceEpoch}',
          captainId: _mockCaptainId,
          rideId: rideId,
          amount: amount,
          note: note,
          createdAt: DateTime.now(),
          status: BidStatus.pending,
        );
        
        // Update ride with new bid
        _mockRides[rideIndex] = ride.copyWith(bids: [...ride.bids, newBid]);
      }
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Start ride
  Future<void> startRide(String rideId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Find ride by ID
      final rideIndex = _mockRides.indexWhere((ride) => ride.id == rideId);
      
      if (rideIndex == -1) {
        throw Exception('Ride not found');
      }
      
      // Update ride status
      _mockRides[rideIndex] = _mockRides[rideIndex].copyWith(
        status: RideStatus.inProgress,
      );
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Complete ride
  Future<void> completeRide(String rideId, double actualFare) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Find ride by ID
      final rideIndex = _mockRides.indexWhere((ride) => ride.id == rideId);
      
      if (rideIndex == -1) {
        throw Exception('Ride not found');
      }
      
      // Update ride status
      _mockRides[rideIndex] = _mockRides[rideIndex].copyWith(
        status: RideStatus.completed,
        completedAt: DateTime.now(),
        actualFare: actualFare,
      );
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Cancel ride
  Future<void> cancelRide(String rideId, String reason) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Find ride by ID
      final rideIndex = _mockRides.indexWhere((ride) => ride.id == rideId);
      
      if (rideIndex == -1) {
        throw Exception('Ride not found');
      }
      
      // Update ride status
      _mockRides[rideIndex] = _mockRides[rideIndex].copyWith(
        status: RideStatus.cancelled,
        cancelledAt: DateTime.now(),
        cancelReason: reason,
      );
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Update ride status
  Future<void> updateRideStatus(String rideId, RideStatus status) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Find ride by ID
      final rideIndex = _mockRides.indexWhere((ride) => ride.id == rideId);
      
      if (rideIndex == -1) {
        throw Exception('Ride not found');
      }
      
      // Update ride status
      _mockRides[rideIndex] = _mockRides[rideIndex].copyWith(
        status: status,
      );
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Rate user
  Future<void> rateUser(String rideId, double rating, String? feedback) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Find ride by ID
      final rideIndex = _mockRides.indexWhere((ride) => ride.id == rideId);
      
      if (rideIndex == -1) {
        throw Exception('Ride not found');
      }
      
      // Update user rating
      _mockRides[rideIndex] = _mockRides[rideIndex].copyWith(
        userRating: rating,
        userFeedback: feedback,
      );
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}