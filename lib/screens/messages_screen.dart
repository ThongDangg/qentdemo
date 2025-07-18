import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qentdemo/providers/userProvider.dart';
import 'package:qentdemo/screens/chatroom_screen.dart';
import 'package:qentdemo/screens/splash_screen.dart';
import 'package:qentdemo/screens/view_profile_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  var db = FirebaseFirestore.instance;
  var user = FirebaseAuth.instance.currentUser; //nhận diện người dùng hiện tại
  List<Map<String, dynamic>> chatroomList = [];
  List<String> chatroomsIds =
      []; //vì ko có chatroom id nên sẽ lấy id của document

  var scaffoldKey = GlobalKey<ScaffoldState>(); //TAOJ GLOBAL KEY cho scaffold

  void getChatrooms() {
    db.collection("chatrooms").get().then((dataSnapshort) {
      //GET TOÀN BỘ CHATROOMS NÊN GET THẲNG VÀO KHÔNG CẦN .DOC
      for (var singleChatroomData
          in dataSnapshort
              .docs) //for adding this list into this chat room list what needs to be done is we need to loop
      {
        chatroomList.add(singleChatroomData.data());
        chatroomsIds.add(
          singleChatroomData.id.toString(),
        ); //lấy id của doc bỏ vào list vừa tạo
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    getChatrooms();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Global Chat "),
        leading: InkWell(
          onTap: () {
            scaffoldKey.currentState!
                .openDrawer(); //MO DRAWER VOI scaffold key //so this is how you replace the default hamburger icon with your custom icon for draw.
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              radius: 20,
              child: Text(
                userProvider.userName.isNotEmpty
                    ? userProvider.userName[0]
                    : "?",
              ),
            ),
          ),
        ), //NAY BAT BUOC XAI TRONG DO AN CUA MINH
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
                        return ViewProfileScreen();
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

      body: ListView.builder(
        itemCount: chatroomList.length,
        itemBuilder: (BuildContext context, int index) {
          String chatroomName = chatroomList[index]["chatroom_name"] ?? "";
          return ListTile(
            onTap: () {
              Navigator.push(
                //xóa lịch sử chỉ navigate tới đúng trang cần tới và kh có nút quay lại
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChatroomScreen(
                      //Nhấn vào cái đoạn chat nào thì hiển thị đoạn chat đó
                      chatroomName: chatroomName,
                      chatroomId: chatroomsIds[index],
                    );
                  },
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(
                chatroomName[0],
                style: TextStyle(color: Colors.white),
              ),
            ), // laays chuwx cai dau cua chatroomname lam avatar
            title: Text(chatroomName),
            subtitle: Text(chatroomList[index]["desc"] ?? ""),
          );
        },
      ),
    );
  }
}
