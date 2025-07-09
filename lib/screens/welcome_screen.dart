import 'package:flutter/material.dart';
import 'package:qentdemo/screens/login_screen.dart';
import 'package:qentdemo/screens/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      'Chào mừng đến Quent',
      'Hãy bắt đầu một trải nghiệm mới với dịch vụ cho thuê xe',
    ];

    final List<String> subtitles = [
      '', // Trang 1 không có subtitle
      'Khám phá chuyến phiêu lưu tiếp theo của bạn cùng Quent.\n'
          'Chúng tôi ở đây để mang đến cho bạn trải nghiệm thuê xe liền mạch.\n'
          'Hãy bắt đầu hành trình của bạn ngay hôm nay.',
    ];

    final List<String> backgroundImages = [
      'assets/images/xe_trang.jpg',
      'assets/images/xe_den.png',
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            //GIỐNG LISTVIEW BUILDER NHƯNG ONE DATA OF LIST IS SHOWN AT A TIME BY SWIPE BETWEEN THE PAGE
            scrollDirection: Axis.horizontal,
            controller: _pageController,

            itemCount: titles.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },

            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Ảnh nền
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(backgroundImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.transparent,
                        ],
                        stops: const [0.4, 0.9],
                      ),
                    ),
                  ),

                  // Nội dung logo + tiêu đề
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SizedBox(height: 65),
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: AssetImage(
                            'assets/images/logo_app.png',
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          titles[index],
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        
                        if (subtitles[index].isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 130),
                            child: Text(
                              subtitles[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 40,
                    left: 25,
                    right: 25,
                    child: index < 1 ? SizedBox.shrink() :  ElevatedButton(
                      onPressed: () async {
                        print("Current index is $index");

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        
                        backgroundColor: Color(0xFF21292B),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                        "Bắt đầu",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ) ,
                  ),
                ],
              );

                
            },
          ),

          //indicatr
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                titles.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 20 : 8, //to hơn nếu đang active
                  height: 8,
                  decoration: BoxDecoration(
                    
                    color: currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                        
                  ),
                ),
              ),
            ),
          ),

          
        ],
      ),
    );
  }
}
