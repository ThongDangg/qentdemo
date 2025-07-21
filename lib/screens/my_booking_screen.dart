import 'package:flutter/material.dart';
import 'package:qentdemo/models/booking_model.dart';
import 'package:qentdemo/services/booking_service.dart';

class MyBookingsScreen extends StatefulWidget {
  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late Future<List<BookingModel>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = BookingService.getBookingsForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đơn đặt xe của tôi")),
      body: FutureBuilder<List<BookingModel>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Bạn chưa có đơn đặt nào"));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: EdgeInsets.all(12),
                child: ListTile(
                  title: Text("Xe: ${booking.carId}"),
                  subtitle: Text(
                    "Ngày nhận: ${booking.bookingDetails.pickupDate.toLocal()}",
                  ),
                  trailing: Text(
                    _statusText(booking.status),
                    style: TextStyle(
                      color: _statusColor(booking.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // bạn có thể mở chi tiết nếu cần
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'in_progress':
        return 'Đang sử dụng';
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Không rõ';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'in_progress':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
