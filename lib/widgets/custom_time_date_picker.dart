import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDateTimePicker extends StatefulWidget {
  const CustomDateTimePicker({super.key});

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  DateTime today = DateTime.now();
  DateTime? rangeStart;
  DateTime? rangeEnd;
  DateTime focusedDay = DateTime.now(); // ✅ tách riêng focusedDay
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    rangeStart = today;
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool isInRange(DateTime day) {
    if (rangeStart == null || rangeEnd == null) return false;
    return day.isAfter(rangeStart!.subtract(const Duration(days: 1))) &&
        day.isBefore(rangeEnd!.add(const Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Chọn ngày & giờ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: buildTimeBox('Giờ bắt đầu', true)),
                const SizedBox(width: 12),
                Expanded(child: buildTimeBox('Giờ kết thúc', false)),
              ],
            ),
            const SizedBox(height: 16),

            TableCalendar(
              focusedDay: focusedDay, // ✅ dùng state focusedDay
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              rangeStartDay: rangeStart,
              rangeEndDay: rangeEnd,
              onDaySelected: (selectedDay, newFocusedDay) {
                setState(() {
                  focusedDay = newFocusedDay; // ✅ Cập nhật
                  if (rangeStart != null && rangeEnd == null) {
                    if (selectedDay.isAfter(rangeStart!)) {
                      rangeEnd = selectedDay;
                    } else {
                      rangeStart = selectedDay;
                    }
                  } else {
                    rangeStart = selectedDay;
                    rangeEnd = null;
                  }
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(day, rangeStart ?? today) ||
                    isSameDay(day, rangeEnd ?? DateTime(2000));
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                rangeStartDecoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                withinRangeDecoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2), // ✅ Chọn 1 màu
                  borderRadius: BorderRadius.circular(10), // ✅ Bo góc nhẹ
                ),
                todayTextStyle: const TextStyle(color: Colors.black),
                selectedTextStyle: const TextStyle(color: Colors.white),
                withinRangeTextStyle: const TextStyle(color: Colors.black),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              locale: 'vi_VN',
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, {
                      'rangeStart': rangeStart,
                      'rangeEnd': rangeEnd,
                      'startTime': startTime,
                      'endTime': endTime,
                    });
                  },
                  child: const Text(
                    'Xong',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTimeBox(String label, bool isStart) {
    final time = isStart ? startTime : endTime;
    return GestureDetector(
      onTap: () => pickTime(isStart),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              time == null ? label : time.format(context),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: isStart ? 'Chọn giờ bắt đầu' : 'Chọn giờ kết thúc',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteTextColor: Colors.black,
              dayPeriodTextColor: Colors.black,
              dialHandColor: Colors.black,
              dialBackgroundColor: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }
}
