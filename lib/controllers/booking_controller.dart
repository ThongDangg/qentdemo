// booking_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qentdemo/factories/booking_factory.dart' as BookingFactory;
import 'package:qentdemo/models/booking_model.dart';
import 'package:qentdemo/models/booking_detail.dart';
import 'package:qentdemo/models/customer_info.dart';
import 'package:qentdemo/models/payment_info.dart';
import 'package:qentdemo/models/pricing_info.dart';
import 'package:qentdemo/models/car_model.dart';

class BookingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBooking({
    required String customerId,
    required Car car,
    required String fullName,
    required String email,
    required String phone,
    required String gender,
    required String address,
    required String rentalType,
    required DateTime pickupDate,
    required DateTime returnDate,
    required bool includeDriver,
    required String paymentMethod,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      // Tính giá (giả định bạn có hàm calculatePricing)
      final pricing = _calculatePricing(
        car: car,
        pickupDate: pickupDate,
        returnDate: returnDate,
        rentalType: rentalType,
        includeDriver: includeDriver,
      );

      // Tạo booking
      final booking = BookingFactory.createFromFormData(
        id: '',
        customerId: customerId,
        carId: car.id,
        fullName: fullName,
        email: email,
        phone: phone,
        gender: gender,
        address: address,
        rentalType: rentalType,
        pickupDate: pickupDate,
        returnDate: returnDate,
        includeDriver: includeDriver,
        paymentMethod: paymentMethod,
        totalAmount: pricing.totalAmount,
        currency: pricing.currency,
        additionalInfo: additionalInfo,
      );

      // Gửi lên Firestore
      await _firestore
          .collection('bookings')
          .doc(booking.id)
          .set(booking.toMap());
    } catch (e) {
      rethrow; // bạn có thể xử lý lỗi ở UI
    }
  }

  PricingInfo _calculatePricing({
    required Car car,
    required DateTime pickupDate,
    required DateTime returnDate,
    required String rentalType,
    required bool includeDriver,
  }) {
    int duration = 1;

    switch (rentalType) {
      case 'Giờ':
        duration = returnDate.difference(pickupDate).inHours;
        break;
      case 'Ngày':
        duration = returnDate.difference(pickupDate).inDays;
        break;
      case 'Tuần':
        duration = (returnDate.difference(pickupDate).inDays / 7).ceil();
        break;
      case 'Tháng':
        duration = (returnDate.difference(pickupDate).inDays / 30).ceil();
        break;
    }

    final basePrice = car.pricePerDay * duration;
    final driverFee = includeDriver ? basePrice * 0.2 : 0.0;
    final tax = (basePrice + driverFee) * 0.1;
    final total = basePrice + driverFee + tax;

    return PricingInfo(
      basePrice: basePrice,
      driverFee: includeDriver ? driverFee : null,
      tax: tax,
      totalAmount: total,
      currency: 'VND',
    );
  }
}
