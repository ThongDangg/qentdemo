import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qentdemo/providers/carProvider.dart';

class BookingDetailScreen extends StatefulWidget {
  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  int currentStep = 0;

  // Controllers để lưu trạng thái
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Biến lưu trạng thái
  bool isDriverIncluded = false;
  String selectedGender = 'Nam';
  String selectedTimeType = 'Ngày';
  DateTime pickupDate = DateTime.now();
  DateTime returnDate = DateTime.now().add(Duration(days: 1));
  String selectedPaymentMethod = '';

  @override
  void initState() {
    super.initState();
    // Set default dates
    pickupDate = DateTime(2024, 11, 19);
    returnDate = DateTime(2024, 11, 22);
  }

  @override
  Widget build(BuildContext context) {

      final selectedCar = Provider.of<CarProvider>(context).selectCar;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chi tiết đặt xe',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                _buildStepIndicator(0, 'Chi tiết đặt xe'),
                Expanded(
                  child: Container(
                    height: 2,
                    color: currentStep > 0 ? Colors.black : Colors.grey[300],
                  ),
                ),
                _buildStepIndicator(1, 'Phương thức thanh toán'),
                Expanded(
                  child: Container(
                    height: 2,
                    color: currentStep > 1 ? Colors.black : Colors.grey[300],
                  ),
                ),
                _buildStepIndicator(2, 'Xác nhận thuê'),
              ],
            ),
          ),

          // Content
          Expanded(child: SingleChildScrollView(child: _buildStepContent())),

          // Bottom Button
          Container(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleNextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  currentStep == 2 ? 'Thanh toán ngay' : 'Tiếp tục',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String title) {
    bool isActive = currentStep >= step;
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black : Colors.grey[300],
      ),
      child: Center(
        child: Text(
          '${step + 1}',
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildBookingDetailsStep();
      case 1:
        return _buildPaymentMethodStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return Container();
    }
  }

  Widget _buildBookingDetailsStep() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver option
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đặt với tài xế ?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Bạn chưa có bằng lái? Hãy đặt kèm tài xế',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              Switch(
                value: isDriverIncluded,
                onChanged: (value) {
                  setState(() {
                    isDriverIncluded = value;
                  });
                },
                activeColor: Colors.black,
              ),
            ],
          ),

          SizedBox(height: 20),

          // Name field
          _buildTextField(
            controller: nameController,
            label: 'Tên đầy đủ*',
            icon: Icons.person_outline,
          ),

          SizedBox(height: 16),

          // Email field
          _buildTextField(
            controller: emailController,
            label: 'Địa chỉ Email*',
            icon: Icons.email_outlined,
          ),

          SizedBox(height: 16),

          // Phone field
          _buildTextField(
            controller: phoneController,
            label: 'Liên hệ*',
            icon: Icons.phone_outlined,
          ),

          SizedBox(height: 20),

          // Gender selection
          Text(
            'Giới tính',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildGenderOption('Nam', Icons.male),
              SizedBox(width: 12),
              _buildGenderOption('Nữ', Icons.female),
              SizedBox(width: 12),
              _buildGenderOption('Khác', Icons.transgender),
            ],
          ),

          SizedBox(height: 20),

          // Time selection
          Text(
            'Ngày & Giờ thuê',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildTimeOption('Giờ'),
              SizedBox(width: 12),
              _buildTimeOption('Ngày'),
              SizedBox(width: 12),
              _buildTimeOption('Tuần'),
              SizedBox(width: 12),
              _buildTimeOption('Tháng'),
            ],
          ),

          SizedBox(height: 20),

          // Date selection
          Row(
            children: [
              Expanded(
                child: _buildDateField('Ngày lấy xe', pickupDate, (date) {
                  setState(() {
                    pickupDate = date;
                  });
                }),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildDateField('Ngày trả', returnDate, (date) {
                  setState(() {
                    returnDate = date;
                  });
                }),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Address field
          _buildTextField(
            controller: addressController,
            label: 'Địa chỉ lấy',
            icon: Icons.location_on_outlined,
            suffixIcon: Icons.my_location,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodStep() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn phương thức thanh toán',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),

          _buildPaymentOption('Thẻ tín dụng/Thẻ ghi nợ', Icons.credit_card),
          SizedBox(height: 12),
          _buildPaymentOption('Ví điện tử', Icons.account_balance_wallet),
          SizedBox(height: 12),
          _buildPaymentOption('Chuyển khoản ngân hàng', Icons.account_balance),
          SizedBox(height: 12),
          _buildPaymentOption('Thanh toán khi nhận xe', Icons.money),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xác nhận thông tin thuê xe',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),

          _buildConfirmationItem('Tên khách hàng', nameController.text),
          _buildConfirmationItem('Email', emailController.text),
          _buildConfirmationItem('Số điện thoại', phoneController.text),
          _buildConfirmationItem('Địa chỉ lấy xe', addressController.text),
          _buildConfirmationItem('Giới tính', selectedGender),
          _buildConfirmationItem('Loại thuê', selectedTimeType),
          _buildConfirmationItem(
            'Ngày lấy xe',
            '${pickupDate.day}/${pickupDate.month}/${pickupDate.year}',
          ),
          _buildConfirmationItem(
            'Ngày trả xe',
            '${returnDate.day}/${returnDate.month}/${returnDate.year}',
          ),
          _buildConfirmationItem(
            'Có tài xế',
            isDriverIncluded ? 'Có' : 'Không',
          ),
          _buildConfirmationItem(
            'Phương thức thanh toán',
            selectedPaymentMethod,
          ),

          SizedBox(height: 20),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng tiền',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '\$1400',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    IconData? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.grey[600])
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            SizedBox(width: 4),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOption(String time) {
    bool isSelected = selectedTimeType == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeType = time;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime date,
    Function(DateTime) onDateChanged,
  ) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
        if (picked != null) {
          onDateChanged(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    bool isSelected = selectedPaymentMethod == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = title;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.grey[600]),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.black : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.black, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Chưa nhập' : value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: value.isEmpty ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNextStep() {
    // Validate từng bước
    if (currentStep == 0) {
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng điền đầy đủ thông tin bắt buộc')),
        );
        return;
      }
    } else if (currentStep == 1) {
      if (selectedPaymentMethod.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng chọn phương thức thanh toán')),
        );
        return;
      }
    }

    // Chuyển bước hoặc xác nhận
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    } else {
      // Bước cuối cùng
      _handleFinalConfirmation();
    }
  }


  void _handleFinalConfirmation() {
    final carProvider = Provider.of<CarProvider>(context, listen: false);
    final selectedCar = carProvider.selectedCar;

    if (selectedCar == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không tìm thấy xe đã chọn')));
      return;
    }

    int numberOfDays = returnDate.difference(pickupDate).inDays;
    if (numberOfDays <= 0) numberOfDays = 1;

    double basePrice = selectedCar.pricePerDay.toDouble();
    double totalAmount = basePrice * numberOfDays;
    double? driverFee = isDriverIncluded ? totalAmount * 0.2 : null;

    // Tạo booking map
    Map<String, dynamic> bookingData = {
      'carId': selectedCar.id,
      'customerInfo': {
        'fullName': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'gender': selectedGender,
        'address': addressController.text,
      },
      'bookingDetails': {
        'pickupDate': pickupDate,
        'returnDate': returnDate,
        'rentalType': selectedTimeType,
        'includeDriver': isDriverIncluded,
        'duration': numberOfDays,
        'durationUnit': 'ngày',
      },
      'paymentInfo': {'method': selectedPaymentMethod, 'status': 'pending'},
      'pricingInfo': {
        'basePrice': basePrice,
        'driverFee': driverFee,
        'totalAmount': totalAmount,
        'currency': 'VND',
      },
      'status': 'pending',
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };

    FirebaseFirestore.instance
        .collection('bookings')
        .add(bookingData)
        .then((docRef) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Đặt xe thành công!')));
          Navigator.pop(context); // hoặc chuyển sang màn hình xác nhận
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi khi đặt xe: $error')));
        });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
