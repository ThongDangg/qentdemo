// services/booking_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qentdemo/models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'bookings';

  // Tạo booking mới
  Future<String> createBooking(BookingModel booking) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(booking.toMap()); //Có dòng này
          //XỬ LÝ THÔNG BÁO KHI ĐẶT XE THÀNH CÔNG
          await FirebaseFirestore.instance.collection('notifications').add({
        'title': 'Đặt xe thành công',
        'message':
            'Bạn đã đặt xe cho ngày ${pickupDateFormatted}. Nhấn để xem chi tiết.',
        'type': 'booking',
        'createdAt': DateTime.now().toIso8601String(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Error creating booking: $e');
    }
  }

  // // Lấy booking theo ID
  // Future<BookingModel?> getBooking(String bookingId) async {
  //   try {
  //     final doc = await _firestore.collection(_collection).doc(bookingId).get();
  //     if (doc.exists) {
  //       return BookingModel.fromMap(doc.data()!, doc.id);
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception('Error getting booking: $e');
  //   }
  // }
  

  static Future<List<BookingModel>> getBookingsForCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('customerId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Cập nhật booking
  Future<void> updateBooking(
    String bookingId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = DateTime.now();
      await _firestore.collection(_collection).doc(bookingId).update(updates);
    } catch (e) {
      throw Exception('Error updating booking: $e');
    }
  }

  // Lấy danh sách booking theo customer
  Future<List<BookingModel>> getBookingsByCustomer(String customerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error getting bookings: $e');
    }
  }

  // Lấy danh sách booking theo trạng thái
  Future<List<BookingModel>> getBookingsByStatus(String status) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error getting bookings by status: $e');
    }
  }

  // Lấy booking theo xe
  Future<List<BookingModel>> getBookingsByCarId(String carId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('carId', isEqualTo: carId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error getting bookings by car: $e');
    }
  }

  // Lấy booking theo khoảng thời gian
  Future<List<BookingModel>> getBookingsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThanOrEqualTo: endDate)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error getting bookings by date range: $e');
    }
  }

  // Xóa booking
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).delete();
    } catch (e) {
      throw Exception('Error deleting booking: $e');
    }
  }

  // Stream để lắng nghe thay đổi booking
  Stream<BookingModel?> watchBooking(String bookingId) {
    return _firestore.collection(_collection).doc(bookingId).snapshots().map((
      doc,
    ) {
      if (doc.exists) {
        return BookingModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    });
  }

  // Stream để lắng nghe danh sách booking của customer
  Stream<List<BookingModel>> watchCustomerBookings(String customerId) {
    return _firestore
        .collection(_collection)
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Kiểm tra xe có khả dụng trong khoảng thời gian không
  Future<bool> isCarAvailable(
    String carId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('carId', isEqualTo: carId)
          .where('status', whereIn: ['confirmed', 'in_progress'])
          .get();

      for (var doc in querySnapshot.docs) {
        final booking = BookingModel.fromMap(doc.data(), doc.id);

        // Kiểm tra overlap thời gian
        if (startDate.isBefore(booking.bookingDetails.returnDate) &&
            endDate.isAfter(booking.bookingDetails.pickupDate)) {
          return false; // Xe đã được đặt trong khoảng thời gian này
        }
      }

      return true; // Xe khả dụng
    } catch (e) {
      throw Exception('Error checking car availability: $e');
    }
    
  }


  

}
