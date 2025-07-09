import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qentdemo/providers/carProvider.dart';
import 'package:qentdemo/providers/userProvider.dart';
import 'package:qentdemo/screens/find_car_screen.dart';
import 'package:qentdemo/screens/login_screen.dart';
import 'package:qentdemo/screens/splash_screen.dart';
import 'package:qentdemo/screens/view_profile_screen.dart';
import 'package:qentdemo/widgets/car_card.dart';
import 'package:qentdemo/widgets/car_card_nearyou.dart';
import 'package:qentdemo/widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Widget _buildBrandLogo(String imagePath, String name) {
  return Padding(
    padding: const EdgeInsets.only(right: 40.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
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
  );
}

class _HomeScreenState extends State<HomeScreen> {
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => FindCarScreen()));
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
    var userProvider = Provider.of<UserProvider>(context);
    var carProvider = Provider.of<CarProvider>(context);

    final cars = carProvider.carList;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false, //cho mất cái thằng hamburger

        elevation: 0,
        //app bar muốn chia đều ra thì title với actions
        title: Row(
          children: [
            InkWell(
              onTap: () {
                scaffoldKey.currentState!
                    .openDrawer(); //MO DRAWER VOI scaffold key //so this is how you replace the default hamburger icon with your custom icon for draw.
              },
              child: CircleAvatar(
                radius: 23,
                backgroundImage: AssetImage('assets/images/logo_app_2.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(width: 15),
            Text(
              "Welcome ${userProvider.userName.isNotEmpty ? userProvider.userName : "?"}",

              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  // xử lý nhấn chuông
                },

                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                  size: 35,
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),

      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 50),

              ListTile(
                //LÀM ĐỒ ÁN PHẢI NHỚ CÁI NÀY ĐỂ LÀM LOGO
                onTap: () {
                  Navigator.push(
                    //xóa lịch sử chỉ navigate tới đúng trang cần tới và kh có nút quay lại
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ViewProfileScreen(); //chua viet function
                      },
                    ),
                  );
                },
                leading: Icon(Icons.people),
                title: Text("Profile"),
              ),

              ListTile(
                //LÀM ĐỒ ÁN PHẢI NHỚ CÁI NÀY ĐỂ LÀM LOGO
                onTap: () async {
                  ; //đụng zô thg firebase.instance là phải có async await
                  Navigator.push(
                    //xóa lịch sử chỉ navigate tới đúng trang cần tới và kh có nút quay lại
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ViewProfileScreen();
                      },
                    ),
                  );
                },

                leading: CircleAvatar(
                  child: Text(
                    userProvider.userName.isNotEmpty
                        ? userProvider.userName[0]
                        : "?", //phai bat buoc username isnot empty
                  ),
                ),
                title: Text(
                  userProvider.userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(userProvider.userEmail),
              ),

              ListTile(
                //LÀM ĐỒ ÁN PHẢI NHỚ CÁI NÀY ĐỂ LÀM LOGO
                onTap: () async {
                  await FirebaseAuth.instance
                      .signOut(); //đụng zô thg firebase.instance là phải có async await
                  Navigator.pushAndRemoveUntil(
                    //xóa lịch sử chỉ navigate tới đúng trang cần tới và kh có nút quay lại
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SplashScreen();
                      },
                    ),
                    (route) {
                      return false;
                    },
                  );
                },
                leading: Icon(Icons.logout),
                title: Text("Logout"),
              ),
            ],
          ),
        ),
      ),

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
                    height: 100, // Chiều cao cố định cho danh sách
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
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

                  // 3.Stack Dòng cao cấp
                  SizedBox(height: 20),
                  Text(
                    'Dòng cao cấp',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  cars.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          height: 237, //237
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cars.length,
                            itemBuilder: (context, index) {
                              final car = cars[index];
                              return SizedBox(
                                width: 186,
                                child: CarCard(car: car),
                              );
                            },
                          ),
                        ),
                  SizedBox(height: 30), //NEARR YOU
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gần bạn',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7F7F7F),
                        ), //MÀU XÁM CHO SUBTITLE
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  cars.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          height: 237, //237
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cars.length,
                            itemBuilder: (context, index) {
                              final car = cars[index];
                              return SizedBox(
                                width: 390,
                                child: CarCardNearyou(car: car),
                              );
                            },
                          ),
                        ),
                                  const SizedBox(height: 100), //nhớ có cái này để cách ra với nav bar

                ],
              ),
            ),
          ),
          Positioned(
            child: CustomBottomNavBar(
              selectedIndex: _currentIndex,
              onItemTapped: _handleNavigation,
            ),
          )
        ],
        
      ),
       
         
    );
  }
}


////