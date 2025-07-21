import 'package:qentdemo/models/car_model.dart';

class PricingInfo {
  final double basePrice;
  final double? driverFee;
  final double? extraFees;
  final double? discount;
  final double? tax;
  final double totalAmount;
  final String currency;
  final Map<String, dynamic>? priceBreakdown;

  PricingInfo({
    required this.basePrice,
    this.driverFee,
    this.extraFees,
    this.discount,
    this.tax,
    required this.totalAmount,
    required this.currency,
    this.priceBreakdown,
  });

  Map<String, dynamic> toMap() {
    return {
      'basePrice': basePrice,
      'driverFee': driverFee,
      'extraFees': extraFees,
      'discount': discount,
      'tax': tax,
      'totalAmount': totalAmount,
      'currency': currency,
      'priceBreakdown': priceBreakdown ?? {},
    };
  }

  factory PricingInfo.fromMap(Map<String, dynamic> map) {
    return PricingInfo(
      basePrice: (map['basePrice'] ?? 0).toDouble(),
      driverFee: map['driverFee']?.toDouble(),
      extraFees: map['extraFees']?.toDouble(),
      discount: map['discount']?.toDouble(),
      tax: map['tax']?.toDouble(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'USD',
      priceBreakdown: map['priceBreakdown'],
    );
  }

  PricingInfo calculatePricing({
    required Car car,
    required int duration,
    required String durationUnit,
    required bool includeDriver,
  }) {
    double basePrice = car.pricePerDay * duration;
    double driverFee = includeDriver ? 50.0 * duration : 0.0;
    double tax = 0.1 * (basePrice + driverFee); // ví dụ 10%
    double totalAmount = basePrice + driverFee + tax;

    return PricingInfo(
      basePrice: basePrice,
      driverFee: driverFee,
      tax: tax,
      totalAmount: totalAmount,
      currency: 'VND',
    );
  }

}
