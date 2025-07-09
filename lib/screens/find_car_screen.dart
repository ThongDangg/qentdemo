import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qentdemo/models/car_model.dart';
import 'package:qentdemo/providers/carProvider.dart';
import 'package:qentdemo/providers/userProvider.dart';
import 'package:qentdemo/screens/brand_car_onclick.dart';
import 'package:qentdemo/screens/login_screen.dart';
import 'package:qentdemo/screens/splash_screen.dart';
import 'package:qentdemo/screens/view_profile_screen.dart';
import 'package:qentdemo/widgets/brand.dart';
import 'package:qentdemo/widgets/car_card.dart';
import 'package:qentdemo/widgets/car_card_nearyou.dart';
import 'package:qentdemo/widgets/custom_bottom_nav_bar.dart';

class FindCarScreen extends StatefulWidget {
  const FindCarScreen({super.key});

  @override
  State<FindCarScreen> createState() => _FindCarScreenState();
}

final List<Brand> brands = [
  Brand(name: 'Tesla', logoPath: 'assets/images/tesla.png'),
  Brand(name: 'Lamborghini', logoPath: 'assets/images/lamborghini.png'),
  Brand(name: 'BMW', logoPath: 'assets/images/bmw.png'),
  Brand(name: 'Ferrari', logoPath: 'assets/images/ferrari.png'),
  Brand(name: 'Huyndai', logoPath: 'assets/images/huyndai.png'),
  Brand(name: 'Kia', logoPath: 'assets/images/kia.png'),
  Brand(name: 'Lexus', logoPath: 'assets/images/lexus.png'),
  Brand(name: 'Vinfast', logoPath: 'assets/images/vinfast.png'),
];

class _FindCarScreenState extends State<FindCarScreen> {
  String? selectedBrand;

  @override
  void initState() {
    super.initState();
    Provider.of<CarProvider>(context, listen: false).fetchCars();
  }

  var user = FirebaseAuth.instance.currentUser;
  //int notificationCount = 5;
  final List<String> _notifications = [
    'Thông báo 1',
    'Thông báo 2',
    'Thông báo 3',
  ];
  int get notificationCount => _notifications.length;

  var scaffoldKey = GlobalKey<ScaffoldState>(); //TAOJ GLOBAL KEY cho scaffold

  int _currentIndex = 0;

  // Hàm xử lý navigation - đơn giản và rõ ràng
  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Home - đã ở đây rồi
        print('Navigating to Home');
        break;
      case 1:
        // Search
        print('Navigating to Search');
        // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        break;
      case 2:
        // Messages
        print('Navigating to Messages');
        // Navigator.push(context, MaterialPageRoute(builder: (context) => MessagesScreen()));
        break;
      case 3:
        // Notifications
        print('Navigating to Notifications');
        // Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
        break;
      case 4:
        // Profile
        print('Navigating to Profile');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var carProvider = Provider.of<CarProvider>(context);

    final cars = carProvider.carList;

    //Filtered cho xe trừ all
    final List<Car> filteredCars = selectedBrand == 'ALL'
        ? carProvider.carList
        : carProvider.getCarsByBrand(selectedBrand);

   Widget carListWidget;

    if (selectedBrand == 'ALL') {
      final cars = carProvider.carList;
      carListWidget = cars.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Positioned.fill(
              // Sử dụng Positioned.fill thay vì SizedBox với height cố định
              child: GridView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(), // Bỏ dòng này để có thể scroll
                itemCount: cars.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 xe mỗi hàng
                  childAspectRatio: 0.775, // điều chỉnh theo Card
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final car = cars[index];
                  return CarCard(car: car);
                },
              ),
            );
    } else {
      carListWidget = const SizedBox.shrink(); // không hiển thị gì cả
    }

    Widget _buildBrandLogo(String imagePath, String name) {
      return Padding(
        padding: const EdgeInsets.only(right: 40.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedBrand = name;
            });

            if (name != 'ALL') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BrandCarOnclick(brand: name),
                ),
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: name == 'ALL' ? Colors.white : Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(imagePath, height: 40, width: 40),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text("HELLO")),

      //Đang bị lỗi khúc này
      body: Stack(
        children: [
          SingleChildScrollView(
            //
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // 1. Thanh tìm kiếm & Bộ lọc
                  const SizedBox(height: 20), // Khoảng cách

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Tìm xe bạn muốn',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: Colors.black,
                        ), // icon giống hình
                      ),
                    ],
                  ),

                  // 2. Tiêu đề Hãng (Bước 5)
                  const SizedBox(height: 20),
                  const Text(
                    'Hãng',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Danh sách cuộn ngang
                  SizedBox(
                    height: 130, // Chiều cao cố định cho danh sách sử từ 100
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildBrandLogo('assets/images/all.jpg', 'all'),

                        _buildBrandLogo(
                          'assets/images/tesla.png',
                          'Tesla',
                        ), // Thay bằng đường dẫn ảnh của bạn
                        _buildBrandLogo(
                          'assets/images/lamborghini.png',
                          'Lamborghini',
                        ),
                        _buildBrandLogo('assets/images/bmw.png', 'BMW'),
                        _buildBrandLogo('assets/images/ferrari.png', 'Ferrari'),
                        _buildBrandLogo('assets/images/huyndai.png', 'Huyndai'),
                        _buildBrandLogo('assets/images/kia.png', 'Kia'),
                        _buildBrandLogo('assets/images/lexus.png', 'Lexus'),
                        _buildBrandLogo('assets/images/vinfast.png', 'Vinfast'),
                      ],
                    ),
                  ),
                  carListWidget,
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Positioned(
            child: CustomBottomNavBar(
              selectedIndex: _currentIndex,
              onItemTapped: _handleNavigation,
            ),
          ),
        ],
      ),
    );
  }
}


////