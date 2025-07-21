import 'package:qentdemo/models/booking_detail.dart';
import 'package:qentdemo/models/booking_model.dart';
import 'package:qentdemo/models/customer_info.dart';
import 'package:qentdemo/models/payment_info.dart';
import 'package:qentdemo/models/pricing_info.dart';

BookingModel createFromFormData({ //TẠO BẢNG TỪ FORM 
  required String id,
  required String customerId,
  required String carId,
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
  required double totalAmount,
  String currency = 'USD',
  Map<String, dynamic>? additionalInfo,
}) {
  final now = DateTime.now();

  // Tính duration
  int duration = 1;
  String durationUnit = 'day';

  switch (rentalType) {
    case 'Giờ':
      duration = returnDate.difference(pickupDate).inHours;
      durationUnit = 'hour';
      break;
    case 'Ngày':
      duration = returnDate.difference(pickupDate).inDays;
      durationUnit = 'day';
      break;
    case 'Tuần':
      duration = (returnDate.difference(pickupDate).inDays / 7).ceil();
      durationUnit = 'week';
      break;
    case 'Tháng':
      duration = (returnDate.difference(pickupDate).inDays / 30).ceil();
      durationUnit = 'month';
      break;
  }
  String _convertPaymentMethod(String vietnameseMethod) {
    switch (vietnameseMethod) {
      case 'Thẻ tín dụng/Thẻ ghi nợ':
        return 'credit_card';
      case 'Ví điện tử':
        return 'e_wallet';
      case 'Chuyển khoản ngân hàng':
        return 'bank_transfer';
      case 'Thanh toán khi nhận xe':
        return 'cash_on_delivery';
      default:
        return 'unknown';
    }
  }

  // Convert payment method từ tiếng Việt sang English
  String convertedPaymentMethod = _convertPaymentMethod(paymentMethod);

  return BookingModel(
    id: id,
    customerId: customerId,
    carId: carId,
    customerInfo: CustomerInfo(
      fullName: fullName,
      email: email,
      phone: phone,
      gender: gender,
      address: address,
      additionalInfo: additionalInfo,
    ),
    bookingDetails: BookingDetails(
      rentalType: rentalType,
      pickupDate: pickupDate,
      returnDate: returnDate,
      pickupLocation: address,
      includeDriver: includeDriver,
      duration: duration,
      durationUnit: durationUnit,
    ),
    paymentInfo: PaymentInfo(method: convertedPaymentMethod, status: 'pending'),
    pricingInfo: PricingInfo(
      basePrice: totalAmount,
      driverFee: includeDriver ? totalAmount * 0.2 : null,
      totalAmount: totalAmount,
      currency: currency,
    ),
    status: 'pending',
    createdAt: now,
    updatedAt: now,
  );
}
