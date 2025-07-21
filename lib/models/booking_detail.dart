  import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDetails {
    final String rentalType; // 'Giờ', 'Ngày', 'Tuần', 'Tháng'
    final DateTime pickupDate;
    final DateTime returnDate;
    final String pickupLocation;
    final String? returnLocation;
    final bool includeDriver;
    final int duration;
    final String durationUnit;
    final Map<String, dynamic>? specialRequests;

    BookingDetails({
      required this.rentalType,
      required this.pickupDate,
      required this.returnDate,
      required this.pickupLocation,
      this.returnLocation,
      required this.includeDriver,
      required this.duration,
      required this.durationUnit,
      this.specialRequests,
    });

    Map<String, dynamic> toMap() {
      return {
        'rentalType': rentalType,
        'pickupDate': pickupDate,
        'returnDate': returnDate,
        'pickupLocation': pickupLocation,
        'returnLocation': returnLocation,
        'includeDriver': includeDriver,
        'duration': duration,
        'durationUnit': durationUnit,
        'specialRequests': specialRequests ?? {},
      };
    }

    factory BookingDetails.fromMap(Map<String, dynamic> map) {
      return BookingDetails(
        rentalType: map['rentalType'] ?? '',
        pickupDate: (map['pickupDate'] as Timestamp).toDate(),
        returnDate: (map['returnDate'] as Timestamp).toDate(),
        pickupLocation: map['pickupLocation'] ?? '',
        returnLocation: map['returnLocation'],
        includeDriver: map['includeDriver'] ?? false,
        duration: map['duration'] ?? 0,
        durationUnit: map['durationUnit'] ?? '',
        specialRequests: map['specialRequests'],
      );
    }
  }
