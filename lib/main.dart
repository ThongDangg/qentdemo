import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qentdemo/firebase_options.dart';
import 'package:qentdemo/providers/carProvider.dart';
import 'package:qentdemo/providers/userProvider.dart';
import 'package:qentdemo/screens/home_screen.dart';
import 'package:qentdemo/screens/splash_screen.dart';
import 'package:qentdemo/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
      //initialize firebase, vừa android vừa ios
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
        // Thêm các provider khác nếu cần
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {

    
    

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: Locale('vi', 'VN'),
      // supportedLocales: [
      //   Locale('vi', 'VN'),
      //   Locale('en', 'US')
      //],
      theme: ThemeData(
        
        brightness: Brightness.light,
        useMaterial3: true,
            scaffoldBackgroundColor: Color(0xFFF8F8F8), // Toàn app nền màu này

        
        
      ),
      home: SplashScreen());
  }
}


// child: Row(children: [
          
        //   CircleAvatar(
        //       radius: 30,
        //       backgroundImage: AssetImage('assets/images/logo_app_2.png'),
        //     ),
        //   SizedBox(width: 16,),
        //    const Text(
        //       'Qent',
        //       style: TextStyle(
        //         fontSize: 36,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.black,
                
        //       ),
        //    )
            
        // ],),

        //KHI BỊ LỖI Ở WELCOME SCREEN THÌ SỬ DỤNG CLASS NÀY
//       class WelcomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // KHÔNG set backgroundColor ở đây
//       body: Stack(
//         children: [
//           // Hình nền
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/background.jpg', // đổi theo đường dẫn bạn dùng
//               fit: BoxFit.cover,
//             ),
//           ),

//           // Nội dung UI trên nền
//           SafeArea(
//             child: Column(
//               children: [
//                 // Nội dung welcome screen ở đây
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
      
      