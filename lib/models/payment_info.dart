import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentInfo {
  final String
  method; // 'credit_card', 'e_wallet', 'bank_transfer', 'cash_on_delivery'
  final String status; // 'pending', 'completed', 'failed', 'refunded'
  final DateTime? paymentDate;
  final String? transactionId;
  final Map<String, dynamic>? paymentDetails;

  PaymentInfo({
    required this.method,
    required this.status,
    this.paymentDate,
    this.transactionId,
    this.paymentDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'status': status,
      'paymentDate': paymentDate,
      'transactionId': transactionId,
      'paymentDetails': paymentDetails ?? {},
    };
  }

  factory PaymentInfo.fromMap(Map<String, dynamic> map) {
    return PaymentInfo(
      method: map['method'] ?? '',
      status: map['status'] ?? '',
      paymentDate: map['paymentDate'] != null
          ? (map['paymentDate'] as Timestamp).toDate()
          : null,
      transactionId: map['transactionId'],
      paymentDetails: map['paymentDetails'],
    );
  }
}
