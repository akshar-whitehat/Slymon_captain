// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/timestamp_helper.dart';

class LocationModel {
  final String id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final String? placeId;

  LocationModel({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    this.placeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'placeId': placeId,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'],
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      placeId: map['placeId'],
    );
  }
}

enum RideStatus {
  pending,
  accepted,
  arriving,
  arrived,
  inProgress,
  completed,
  cancelled,
}

class BidModel {
  final String id;
  final String captainId;
  final String rideId;
  final double amount;
  final String? note;
  final DateTime createdAt;
  final BidStatus status;

  BidModel({
    required this.id,
    required this.captainId,
    required this.rideId,
    required this.amount,
    this.note,
    required this.createdAt,
    this.status = BidStatus.pending,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'captainId': captainId,
      'rideId': rideId,
      'amount': amount,
      'note': note,
      'createdAt': createdAt,
      'status': status.toString().split('.').last,
    };
  }

  factory BidModel.fromMap(Map<String, dynamic> map) {
    return BidModel(
      id: map['id'] ?? '',
      captainId: map['captainId'] ?? '',
      rideId: map['rideId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      note: map['note'],
      createdAt: _parseTimestamp(map['createdAt']),
      status: BidStatus.values.firstWhere(
        (status) => status.toString().split('.').last == map['status'],
        orElse: () => BidStatus.pending,
      ),
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    return TimestampHelper.parseTimestamp(timestamp);
  }
}

enum BidStatus {
  pending,
  accepted,
  rejected,
}

class RideModel {
  final String id;
  final String userId;
  final String? captainId;
  final LocationModel pickup;
  final LocationModel dropoff;
  final DateTime scheduledTime;
  final double estimatedFare;
  final int estimatedDuration; // in minutes
  final double estimatedDistance; // in kilometers
  final RideStatus status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancelReason;
  final double? actualFare;
  final List<BidModel> bids;
  final String? selectedBidId;
  final double? userRating;
  final double? captainRating;
  final String? userFeedback;
  final String? captainFeedback;

  RideModel({
    required this.id,
    required this.userId,
    this.captainId,
    required this.pickup,
    required this.dropoff,
    required this.scheduledTime,
    required this.estimatedFare,
    required this.estimatedDuration,
    required this.estimatedDistance,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelReason,
    this.actualFare,
    required this.bids,
    this.selectedBidId,
    this.userRating,
    this.captainRating,
    this.userFeedback,
    this.captainFeedback,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'captainId': captainId,
      'pickup': pickup.toMap(),
      'dropoff': dropoff.toMap(),
      'scheduledTime': scheduledTime,
      'estimatedFare': estimatedFare,
      'estimatedDuration': estimatedDuration,
      'estimatedDistance': estimatedDistance,
      'status': status.toString().split('.').last,
      'createdAt': createdAt,
      'acceptedAt': acceptedAt,
      'completedAt': completedAt,
      'cancelledAt': cancelledAt,
      'cancelReason': cancelReason,
      'actualFare': actualFare,
      'bids': bids.map((bid) => bid.toMap()).toList(),
      'selectedBidId': selectedBidId,
      'userRating': userRating,
      'captainRating': captainRating,
      'userFeedback': userFeedback,
      'captainFeedback': captainFeedback,
    };
  }

  factory RideModel.fromMap(Map<String, dynamic> map) {
    return RideModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      captainId: map['captainId'],
      pickup: LocationModel.fromMap(map['pickup'] ?? {}),
      dropoff: LocationModel.fromMap(map['dropoff'] ?? {}),
      scheduledTime: _parseTimestamp(map['scheduledTime']),
      estimatedFare: (map['estimatedFare'] ?? 0.0).toDouble(),
      estimatedDuration: map['estimatedDuration'] ?? 0,
      estimatedDistance: (map['estimatedDistance'] ?? 0.0).toDouble(),
      status: RideStatus.values.firstWhere(
        (status) => status.toString().split('.').last == map['status'],
        orElse: () => RideStatus.pending,
      ),
      createdAt: _parseTimestamp(map['createdAt']),
      acceptedAt: map['acceptedAt'] != null ? _parseTimestamp(map['acceptedAt']) : null,
      completedAt: map['completedAt'] != null ? _parseTimestamp(map['completedAt']) : null,
      cancelledAt: map['cancelledAt'] != null ? _parseTimestamp(map['cancelledAt']) : null,
      cancelReason: map['cancelReason'],
      actualFare: map['actualFare']?.toDouble(),
      bids: map['bids'] != null
          ? List<BidModel>.from(map['bids'].map((x) => BidModel.fromMap(x)))
          : [],
      selectedBidId: map['selectedBidId'],
      userRating: map['userRating']?.toDouble(),
      captainRating: map['captainRating']?.toDouble(),
      userFeedback: map['userFeedback'],
      captainFeedback: map['captainFeedback'],
    );
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    return TimestampHelper.parseTimestamp(timestamp);
  }

  RideModel copyWith({
    String? captainId,
    RideStatus? status,
    DateTime? acceptedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancelReason,
    double? actualFare,
    List<BidModel>? bids,
    String? selectedBidId,
    double? userRating,
    double? captainRating,
    String? userFeedback,
    String? captainFeedback,
  }) {
    return RideModel(
      id: id,
      userId: userId,
      captainId: captainId ?? this.captainId,
      pickup: pickup,
      dropoff: dropoff,
      scheduledTime: scheduledTime,
      estimatedFare: estimatedFare,
      estimatedDuration: estimatedDuration,
      estimatedDistance: estimatedDistance,
      status: status ?? this.status,
      createdAt: createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelReason: cancelReason ?? this.cancelReason,
      actualFare: actualFare ?? this.actualFare,
      bids: bids ?? this.bids,
      selectedBidId: selectedBidId ?? this.selectedBidId,
      userRating: userRating ?? this.userRating,
      captainRating: captainRating ?? this.captainRating,
      userFeedback: userFeedback ?? this.userFeedback,
      captainFeedback: captainFeedback ?? this.captainFeedback,
    );
  }
}