// import 'package:cloud_firestore/cloud_firestore.dart';

enum VehicleType {
  car,
  bike,
  auto,
}

class VehicleModel {
  final String id;
  final String number;
  final String model;
  final VehicleType type;
  final String registrationUrl;
  final bool isVerified;

  VehicleModel({
    required this.id,
    required this.number,
    required this.model,
    required this.type,
    required this.registrationUrl,
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'model': model,
      'type': type.toString().split('.').last,
      'registrationUrl': registrationUrl,
      'isVerified': isVerified,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'] ?? '',
      number: map['number'] ?? '',
      model: map['model'] ?? '',
      type: VehicleType.values.firstWhere(
        (type) => type.toString().split('.').last == map['type'],
        orElse: () => VehicleType.car,
      ),
      registrationUrl: map['registrationUrl'] ?? '',
      isVerified: map['isVerified'] ?? false,
    );
  }
}

class CaptainModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final double walletBalance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String drivingLicenseUrl;
  final bool isVerified;
  final bool isOnline;
  final double rating;
  final int totalRides;
  final double totalEarnings;
  final VehicleModel vehicle;
  final double currentLatitude;
  final double currentLongitude;

  CaptainModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.walletBalance,
    required this.createdAt,
    required this.updatedAt,
    required this.drivingLicenseUrl,
    required this.isVerified,
    required this.isOnline,
    required this.rating,
    required this.totalRides,
    required this.totalEarnings,
    required this.vehicle,
    required this.currentLatitude,
    required this.currentLongitude,
  });

  factory CaptainModel.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return CaptainModel(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      walletBalance: (data['walletBalance'] ?? 0.0).toDouble(),
      createdAt: _parseTimestamp(data['createdAt']),
      updatedAt: _parseTimestamp(data['updatedAt']),
      drivingLicenseUrl: data['drivingLicenseUrl'] ?? '',
      isVerified: data['isVerified'] ?? false,
      isOnline: data['isOnline'] ?? false,
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalRides: data['totalRides'] ?? 0,
      totalEarnings: (data['totalEarnings'] ?? 0.0).toDouble(),
      vehicle: VehicleModel.fromMap(data['vehicle'] ?? {}),
      currentLatitude: (data['currentLatitude'] ?? 0.0).toDouble(),
      currentLongitude: (data['currentLongitude'] ?? 0.0).toDouble(),
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    // Firebase Timestamp handling is commented out for demo mode
    // if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is DateTime) return timestamp;
    if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'walletBalance': walletBalance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'drivingLicenseUrl': drivingLicenseUrl,
      'isVerified': isVerified,
      'isOnline': isOnline,
      'rating': rating,
      'totalRides': totalRides,
      'totalEarnings': totalEarnings,
      'vehicle': vehicle.toMap(),
      'currentLatitude': currentLatitude,
      'currentLongitude': currentLongitude,
    };
  }

  CaptainModel copyWith({
    String? name,
    String? phone,
    String? photoUrl,
    double? walletBalance,
    String? drivingLicenseUrl,
    bool? isVerified,
    bool? isOnline,
    double? rating,
    int? totalRides,
    double? totalEarnings,
    VehicleModel? vehicle,
    double? currentLatitude,
    double? currentLongitude,
  }) {
    return CaptainModel(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      walletBalance: walletBalance ?? this.walletBalance,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      drivingLicenseUrl: drivingLicenseUrl ?? this.drivingLicenseUrl,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      rating: rating ?? this.rating,
      totalRides: totalRides ?? this.totalRides,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      vehicle: vehicle ?? this.vehicle,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
    );
  }
}