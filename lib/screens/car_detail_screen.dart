import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qentdemo/models/car_model.dart';
import 'package:qentdemo/providers/carProvider.dart';
import 'package:qentdemo/providers/userProvider.dart';
import 'package:qentdemo/screens/booking_detail_screen.dart';
import 'package:qentdemo/widgets/car_feature_card.dart';
import 'package:intl/intl.dart';

class CarDetailScreen extends StatefulWidget {
  final Car car;
  CarDetailScreen({Key? key, required this.car}) : super(key: key);


  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  bool isExpanded = false; // 👈 Trạng thái hiển thị mô tả

  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildImageCarousel(List<String> images) {
    Widget _buildPageView() {
      return PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) =>
                  Center(child: Icon(Icons.error)),
            ),
          );
        },
      );
    }

    Widget _buildImageBox() {
      return Container(
        height: 220, // thấp nhẹ lại một chút cho cảm giác tinh tế
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F8), // màu nền xám rất nhạt, không trắng gắt
          borderRadius: BorderRadius.circular(12), // bo nhẹ thôi
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), // rất nhẹ
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias, // tự động bo tròn nội dung bên trong
        child: _buildPageView(), // không cần ClipRRect nữa
      );
    }

    Widget _buildPageIndicator() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          images.length,
          (index) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 10 : 9,
            height: _currentPage == index ? 10 : 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? Color(0xFF454545)
                  : Colors.grey.shade400,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildImageBox(), // Box ngoài đẹp hơn SizedBox
        SizedBox(height: 12),
        _buildPageIndicator(), // chấm tròn indicator

        SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {


    //format tiền
    final formattedPrice = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
    ).format(widget.car.pricePerDay);

    var userProvider = Provider.of<UserProvider>(context);

    final car = widget.car;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        title: Text('Chi tiết xe', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Car image carousel
            SizedBox(height: 16),
            buildImageCarousel(car.imageCarousel),

            // Car info section
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ✅ Bọc Column bên trái trong Expanded để tránh overflow
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.name ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Text(
                                widget.car.desc ?? "Mô tả đang cập nhật",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                                softWrap: true,
                                overflow: isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                                maxLines: isExpanded ? null : 3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Phần đánh giá bên phải
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '${widget.car.rating.toStringAsFixed(1)} đánh giá',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        child: Text(
                          userProvider.userName.isNotEmpty
                              ? userProvider.userName[0]
                              : "?",
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        userProvider.userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.verified, color: Colors.blue, size: 18),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.phone_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.chat_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
                
              ),
              
            ),

            Stack(
              children: [
            Container(
              
              color: Colors.white,
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Chức năng chính của xe", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 25, //35
                    runSpacing: 15, //15
                    children: [
                      CarFeature(
                        title: 'Chỗ ngồi',
                        value: '${car.seats} chỗ',
                        icon: Icons.event_seat,
                      ),
                      CarFeature(
                        title: 'Động cơ ra',
                        value: '${car.horsePower} HP',
                        icon: Icons.ev_station,
                      ),
                      CarFeature(
                        title: 'Tốc độ tối đa',
                        value: '${car.maxSpeed}km/h',
                        icon: Icons.speed,
                      ),
                      CarFeature(
                        title: 'Nâng cao',
                        value: 'Lái tự động',
                        icon: Icons.drive_eta,
                      ),
                      CarFeature(
                        title: 'Phí duy nhất',
                        value: '${formattedPrice}/Ngày',
                        icon: Icons.price_change,
                      ),
                      CarFeature(
                        title: 'Nâng cao',
                        value: 'Bãi đậu xe ô tô',
                        icon: Icons.local_parking,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

            // Review section
            Container(
              color: Colors.white,
           
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhận xét (125)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  ReviewItem(
                    name: 'J97',
                    rating: 5.0,
                    content:
                        'Xe cho thuê sạch sẽ, đáng tin cậy, chủ động và nhanh chóng hỗ trợ.',
                  ),
                  SizedBox(height: 12),
                  ReviewItem(
                    name: 'Anh Hòa',
                    rating: 5.0,
                    content:
                        'Xe cho thuê sạch sẽ, đáng tin cậy, chủ động và nhanh chóng hỗ trợ.',
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                      context.read<CarProvider>().selectCar(
                                car,
                              ); // 👈 Gán xe vào Provider

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BookingDetailScreen(
                                      
                                    );
                          },
                        ),
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text('Đặt Ngay', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              
            ),
                ],
                
              ),
              
            ),
            SizedBox(height: 30),
            
              ],
            )
            
,
            
            
          ],
        ),
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final String name;
  final double rating;
  final String content;

  ReviewItem({
    Key? key,
    required this.name,
    required this.rating,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(backgroundImage: AssetImage('assets/images/avatar.png')),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < rating ? Colors.orange : Colors.grey,
                    size: 16,
                  );
                }),
              ),
              SizedBox(height: 4),
              Text(content),
            ],
          ),
        ),
      ],
    );
  }
}
