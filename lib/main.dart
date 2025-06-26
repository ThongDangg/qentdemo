import 'package:flutter/material.dart';
import 'package:qentdemo/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: WelcomeScreen(),); 
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

        
      
      
      