import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qentdemo/models/booking_detail.dart';
import 'package:qentdemo/models/customer_info.dart';
import 'package:qentdemo/models/payment_info.dart';
import 'package:qentdemo/models/pricing_info.dart';

class BookingModel {
  final String id;
  final String customerId;
  final String carId;
  final CustomerInfo customerInfo;
  final BookingDetails bookingDetails;
  final PaymentInfo paymentInfo;
  final PricingInfo pricingInfo;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  BookingModel({
    required this.id,
    required this.customerId,
    required this.carId,
    required this.customerInfo,
    required this.bookingDetails,
    required this.paymentInfo,
    required this.pricingInfo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  Map<String, dynamic> toMap() { //LƯU FORM VÀO FIRESTORE ĐỐI VỚI FORM TRÊN UI
    return {
      'customerId': customerId,
      'carId': carId,
      'customerInfo': customerInfo.toMap(),
      'bookingDetails': bookingDetails.toMap(),
      'paymentInfo': paymentInfo.toMap(),
      'pricingInfo': pricingInfo.toMap(),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'metadata': metadata ?? {},
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BookingModel(
      id: documentId,
      customerId: map['customerId'] ?? '',
      carId: map['carId'] ?? '',
      customerInfo: CustomerInfo.fromMap(map['customerInfo'] ?? {}),
      bookingDetails: BookingDetails.fromMap(map['bookingDetails'] ?? {}),
      paymentInfo: PaymentInfo.fromMap(map['paymentInfo'] ?? {}),
      pricingInfo: PricingInfo.fromMap(map['pricingInfo'] ?? {}),
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  BookingModel copyWith({
    String? id,
    String? customerId,
    String? carId,
    CustomerInfo? customerInfo,
    BookingDetails? bookingDetails,
    PaymentInfo? paymentInfo,
    PricingInfo? pricingInfo,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      carId: carId ?? this.carId,
      customerInfo: customerInfo ?? this.customerInfo,
      bookingDetails: bookingDetails ?? this.bookingDetails,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      pricingInfo: pricingInfo ?? this.pricingInfo,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}
