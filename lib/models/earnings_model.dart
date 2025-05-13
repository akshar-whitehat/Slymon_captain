// import 'package:cloud_firestore/cloud_firestore.dart';

class EarningsModel {
  final String id;
  final String captainId;
  final String rideId;
  final double amount;
  final DateTime date;
  final String? description;
  final EarningsType type;

  EarningsModel({
    required this.id,
    required this.captainId,
    required this.rideId,
    required this.amount,
    required this.date,
    this.description,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'captainId': captainId,
      'rideId': rideId,
      'amount': amount,
      'date': date,
      'description': description,
      'type': type.toString().split('.').last,
    };
  }

  factory EarningsModel.fromMap(Map<String, dynamic> map) {
    return EarningsModel(
      id: map['id'] ?? '',
      captainId: map['captainId'] ?? '',
      rideId: map['rideId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      date: _parseTimestamp(map['date']),
      description: map['description'],
      type: EarningsType.values.firstWhere(
        (type) => type.toString().split('.').last == map['type'],
        orElse: () => EarningsType.ride,
      ),
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    // Commented out for demo mode (no Firebase)
    // if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is DateTime) return timestamp;
    if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now();
  }
}

enum EarningsType {
  ride,
  bonus,
  referral,
  withdrawal,
}

class EarningsSummary {
  final double todayEarnings;
  final double weeklyEarnings;
  final double monthlyEarnings;
  final double totalEarnings;
  final int totalRides;
  final double totalDistance;

  EarningsSummary({
    required this.todayEarnings,
    required this.weeklyEarnings,
    required this.monthlyEarnings,
    required this.totalEarnings,
    required this.totalRides,
    required this.totalDistance,
  });

  factory EarningsSummary.empty() {
    return EarningsSummary(
      todayEarnings: 0.0,
      weeklyEarnings: 0.0,
      monthlyEarnings: 0.0,
      totalEarnings: 0.0,
      totalRides: 0,
      totalDistance: 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'todayEarnings': todayEarnings,
      'weeklyEarnings': weeklyEarnings,
      'monthlyEarnings': monthlyEarnings,
      'totalEarnings': totalEarnings,
      'totalRides': totalRides,
      'totalDistance': totalDistance,
    };
  }

  factory EarningsSummary.fromMap(Map<String, dynamic> map) {
    return EarningsSummary(
      todayEarnings: (map['todayEarnings'] ?? 0.0).toDouble(),
      weeklyEarnings: (map['weeklyEarnings'] ?? 0.0).toDouble(),
      monthlyEarnings: (map['monthlyEarnings'] ?? 0.0).toDouble(),
      totalEarnings: (map['totalEarnings'] ?? 0.0).toDouble(),
      totalRides: map['totalRides'] ?? 0,
      totalDistance: (map['totalDistance'] ?? 0.0).toDouble(),
    );
  }
}