import 'package:flutter/material.dart';
import 'custom_time_date_picker.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int selectedType = 0;
  RangeValues priceRange = const RangeValues(10, 230);
  int selectedRentalTime = 0;
  int selectedCapacity = 4;
  String selectedFuel = 'Electric';
  String selectedColor = 'Black';
  String carLocation = '';

  DateTime? startDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close),
                  ),
                  const Text(
                    'Bộ lọc',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Loại xe
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Loại xe',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  typeChip(0, 'Tất cả xe'),
                  typeChip(1, 'Xe phổ thông'),
                  typeChip(2, 'Xe sang'),
                ],
              ),
            ),
            const Divider(height: 32),

            // Khoảng giá
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Khoảng giá',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RangeSlider(
                values: priceRange,
                min: 10,
                max: 230,
                onChanged: (values) {
                  setState(() {
                    priceRange = values;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Từ \$${priceRange.start.toInt()}'),
                  Text('Đến \$${priceRange.end.toInt()}+'),
                ],
              ),
            ),
            const Divider(height: 32),

            // Thời gian thuê
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Thời gian thuê',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                children: [
                  rentalChip(0, 'Giờ'),
                  rentalChip(1, 'Ngày'),
                  rentalChip(2, 'Tuần'),
                  rentalChip(3, 'Tháng'),
                ],
              ),
            ),
            const Divider(height: 32),

            // Ngày & giờ nhận trả
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ngày & Giờ nhận/trả xe',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () async {
                      final result = await showDialog(
                        context: context,
                        builder:
                            (_) => const Dialog(
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              child: CustomDateTimePicker(),
                            ),
                      );
                      if (result != null) {
                        setState(() {
                          startDate = result['date'] as DateTime;
                          startTime = result['startTime'] as TimeOfDay;
                          endTime = result['endTime'] as TimeOfDay;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          startDate != null
                              ? '${startDate!.day}/${startDate!.month} ${startTime?.format(context) ?? ''} - ${endTime?.format(context) ?? ''}'
                              : 'Chưa chọn',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),

            // Địa điểm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Địa điểm xe',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Nhập vị trí',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                onChanged: (value) {
                  setState(() {
                    carLocation = value;
                  });
                },
              ),
            ),
            const Divider(height: 32),

            // Màu sắc
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Màu sắc',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Xem tất cả', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                children: [
                  colorCircle('Trắng', Colors.white),
                  colorCircle('Xám', Colors.grey),
                  colorCircle('Xanh', Colors.blue),
                  colorCircle('Đen', Colors.black),
                ],
              ),
            ),
            const Divider(height: 32),

            // Số chỗ ngồi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Số chỗ ngồi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                children: [
                  capacityChip(2),
                  capacityChip(4),
                  capacityChip(6),
                  capacityChip(8),
                ],
              ),
            ),
            const Divider(height: 32),

            // Nhiên liệu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Loại nhiên liệu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                children: [
                  fuelChip('Điện'),
                  fuelChip('Xăng'),
                  fuelChip('Dầu'),
                  fuelChip('Lai'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // HÀNG NÚT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: clearAll,
                    child: const Text(
                      'Xóa tất cả',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C1C1E),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      print('Loại xe: $selectedType');
                      print('Khoảng giá: $priceRange');
                      print('Thời gian thuê: $selectedRentalTime');
                      print('Ngày: $startDate $startTime - $endTime');
                      print('Vị trí: $carLocation');
                      Navigator.of(context).pop();
                    },
                    child: const Text('Hiển thị 100+ xe'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget typeChip(int index, String label) {
    final isSelected = selectedType == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1C1C1E) : Colors.transparent,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget rentalChip(int index, String label) {
    final isSelected = selectedRentalTime == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRentalTime = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1C1C1E) : Colors.transparent,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget capacityChip(int capacity) {
    final isSelected = selectedCapacity == capacity;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCapacity = capacity;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1C1C1E) : Colors.transparent,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          '$capacity',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget fuelChip(String label) {
    final isSelected = selectedFuel == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFuel = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1C1C1E) : Colors.transparent,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget colorCircle(String color, Color colorValue) {
    final isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorValue,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 2,
          ),
        ),
      ),
    );
  }

  void clearAll() {
    setState(() {
      selectedType = 0;
      priceRange = const RangeValues(10, 230);
      selectedRentalTime = 0;
      selectedCapacity = 4;
      selectedFuel = 'Electric';
      selectedColor = 'Black';
      carLocation = '';
      startDate = null;
      startTime = null;
      endTime = null;
    });
  }
}
