// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/earnings_model.dart';
import '../services/auth_service.dart';

class EarningsService extends ChangeNotifier {
  // Reference to the mock auth service
  final AuthService? _authService;
  
  // Mock earnings data
  List<EarningsModel> _mockEarnings = [];
  
  // Constructor
  EarningsService({AuthService? authService}) : _authService = authService {
    // Initialize with mock data
    _initializeMockData();
  }
  
  void _initializeMockData() {
    final now = DateTime.now();
    
    // Create mock earnings data
    _mockEarnings = [
      // Today's earnings
      EarningsModel(
        id: 'earning-001',
        captainId: 'captain-001',
        rideId: 'ride-001',
        amount: 350.0,
        date: DateTime(now.year, now.month, now.day, 10, 30),
        description: 'Ride from Indiranagar to Koramangala',
        type: EarningsType.ride,
      ),
      EarningsModel(
        id: 'earning-002',
        captainId: 'captain-001',
        rideId: 'ride-002',
        amount: 420.0,
        date: DateTime(now.year, now.month, now.day, 14, 15),
        description: 'Ride from Whitefield to Electronic City',
        type: EarningsType.ride,
      ),
      
      // This week's earnings
      EarningsModel(
        id: 'earning-003',
        captainId: 'captain-001',
        rideId: 'ride-003',
        amount: 280.0,
        date: now.subtract(const Duration(days: 1)),
        description: 'Ride from HSR Layout to Marathahalli',
        type: EarningsType.ride,
      ),
      EarningsModel(
        id: 'earning-004',
        captainId: 'captain-001',
        rideId: 'ride-004',
        amount: 500.0,
        date: now.subtract(const Duration(days: 2)),
        description: 'Ride from Airport to City Center',
        type: EarningsType.ride,
      ),
      EarningsModel(
        id: 'earning-005',
        captainId: 'captain-001',
        rideId: '',
        amount: 200.0,
        date: now.subtract(const Duration(days: 3)),
        description: 'Bonus for completing 10 rides',
        type: EarningsType.bonus,
      ),
      
      // This month's earnings
      EarningsModel(
        id: 'earning-006',
        captainId: 'captain-001',
        rideId: 'ride-005',
        amount: 320.0,
        date: now.subtract(const Duration(days: 10)),
        description: 'Ride from MG Road to Yelahanka',
        type: EarningsType.ride,
      ),
      EarningsModel(
        id: 'earning-007',
        captainId: 'captain-001',
        rideId: 'ride-006',
        amount: 180.0,
        date: now.subtract(const Duration(days: 12)),
        description: 'Ride from JP Nagar to Bannerghatta',
        type: EarningsType.ride,
      ),
      EarningsModel(
        id: 'earning-008',
        captainId: 'captain-001',
        rideId: '',
        amount: 300.0,
        date: now.subtract(const Duration(days: 15)),
        description: 'Referral bonus',
        type: EarningsType.referral,
      ),
      
      // Previous month
      EarningsModel(
        id: 'earning-009',
        captainId: 'captain-001',
        rideId: '',
        amount: -1000.0,
        date: now.subtract(const Duration(days: 35)),
        description: 'Withdrawal to bank account',
        type: EarningsType.withdrawal,
      ),
      EarningsModel(
        id: 'earning-010',
        captainId: 'captain-001',
        rideId: 'ride-007',
        amount: 450.0,
        date: now.subtract(const Duration(days: 40)),
        description: 'Ride from Hebbal to Kengeri',
        type: EarningsType.ride,
      ),
    ];
  }
  
  // Get earnings summary
  Future<EarningsSummary> getEarningsSummary() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final startOfWeek = DateTime(now.year, now.month, now.day - now.weekday + 1);
      final startOfMonth = DateTime(now.year, now.month, 1);
      
      // Calculate today's earnings
      double todayEarnings = 0.0;
      for (final earning in _mockEarnings) {
        if (earning.date.isAfter(startOfDay) && earning.amount > 0) {
          todayEarnings += earning.amount;
        }
      }
      
      // Calculate weekly earnings
      double weeklyEarnings = 0.0;
      for (final earning in _mockEarnings) {
        if (earning.date.isAfter(startOfWeek) && earning.amount > 0) {
          weeklyEarnings += earning.amount;
        }
      }
      
      // Calculate monthly earnings
      double monthlyEarnings = 0.0;
      for (final earning in _mockEarnings) {
        if (earning.date.isAfter(startOfMonth) && earning.amount > 0) {
          monthlyEarnings += earning.amount;
        }
      }
      
      // Calculate total earnings
      double totalEarnings = 0.0;
      for (final earning in _mockEarnings) {
        if (earning.amount > 0) {
          totalEarnings += earning.amount;
        }
      }
      
      // Count total rides
      int totalRides = _mockEarnings.where((e) => e.type == EarningsType.ride).length;
      
      // Calculate total distance (mock value)
      double totalDistance = totalRides * 8.5; // Assuming average ride distance is 8.5 km
      
      return EarningsSummary(
        todayEarnings: todayEarnings,
        weeklyEarnings: weeklyEarnings,
        monthlyEarnings: monthlyEarnings,
        totalEarnings: totalEarnings,
        totalRides: totalRides,
        totalDistance: totalDistance,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  // Get earnings history
  Stream<List<EarningsModel>> getEarningsHistory() {
    // Simulate a stream of earnings data
    return Stream.value(_mockEarnings)
        .asyncMap((earnings) async {
          // Simulate network delay
          await Future.delayed(const Duration(milliseconds: 800));
          return earnings;
        });
  }
  
  // Get earnings by date range
  Future<List<EarningsModel>> getEarningsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Filter earnings by date range
      return _mockEarnings
          .where((earning) => 
              earning.date.isAfter(startDate) && 
              earning.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
  
  // Request withdrawal
  Future<void> requestWithdrawal(double amount, String bankAccount) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Check if amount is valid
      if (amount <= 0) {
        throw Exception('Invalid amount');
      }
      
      // Check if captain has enough balance
      final captainData = await _authService?.getCaptainData();
      final walletBalance = captainData?.walletBalance ?? 0.0;
      
      if (walletBalance < amount) {
        throw Exception('Insufficient balance');
      }
      
      // Add withdrawal to earnings history
      final now = DateTime.now();
      final withdrawal = EarningsModel(
        id: 'withdrawal-${now.millisecondsSinceEpoch}',
        captainId: 'captain-001',
        rideId: '',
        amount: -amount,
        date: now,
        description: 'Withdrawal to bank account',
        type: EarningsType.withdrawal,
      );
      
      _mockEarnings.insert(0, withdrawal);
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}