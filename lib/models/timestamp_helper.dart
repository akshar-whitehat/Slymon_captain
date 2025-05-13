// Helper class to handle timestamp parsing without Firebase
class TimestampHelper {
  static DateTime parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    // Firebase Timestamp handling is commented out for demo mode
    // if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is DateTime) return timestamp;
    if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now();
  }
}