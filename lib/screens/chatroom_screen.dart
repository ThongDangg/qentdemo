import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qentdemo/providers/userProvider.dart';

class ChatroomScreen extends StatefulWidget {
  String chatroomName;
  String chatroomId;

  ChatroomScreen({
    super.key,
    required this.chatroomId,
    required this.chatroomName,
  });

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  var db = FirebaseFirestore.instance;

  TextEditingController messageText = TextEditingController();

  Future<void> sendMessage() async {
    //cấu trúc map để đưa message vào database dùng provider để quản lý người gửi
    //CÓ THỂ DÙNG CHO ĐẶT XE ĐƯỢC

    if (messageText.text.isEmpty) {
      print("Message is empty, skipping send");

      return;
    }

    var userName = Provider.of<UserProvider>(context, listen: false).userName;
    var userId = Provider.of<UserProvider>(context, listen: false).userId;

    print("userName: $userName"); // debug xem userName có null ko

    Map<String, dynamic> messsageToSend = {
      "text": messageText.text,
      "sender_name": userName,
      "sender_id": userId,
      "chatroom_id": widget.chatroomId,
      "timestamp":
          FieldValue.serverTimestamp(), //the time automatically retrieved by cloud firestore
    };

    print("sending: $messsageToSend");
    messageText.text = "";
    try {
      await db.collection("messages").add(messsageToSend);
      print("sent to Firestore OK");
      ////Firestore tự động tạo ID cho mỗi tin nhắn, giống như trong chatroom trước đó.=> vì vậy không dùng doc("id"), mà dùng .add()
    } catch (e) {
      print("send message error: $e");
    }
  }

  Widget singleChatItem({
    required String sender_name,
    required String text,
    required String sender_id,
  }) {
    return Column(
      crossAxisAlignment:
          sender_id == Provider.of<UserProvider>(context, listen: false).userId
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start, //CHÉO QUA CHÉO LẠI
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 6),
          child: Text(
            sender_name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color:
                sender_id ==
                    Provider.of<UserProvider>(context, listen: false).userId
                ? Colors.grey[300]
                : Colors.blueGrey,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              text,
              style: TextStyle(
                color:
                    sender_id ==
                        Provider.of<UserProvider>(context, listen: false).userId
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatroomName)),
      body: Column(
        children: [
          Expanded(
            child:
                //Ly thuyet Stream Builder
                //           So now the stream builder will look for the data changes in this collection.
                // And when the data is changed this builder function is executed.
                // And the updated data is available on this snapshot argument.
                // All right.
                // So whenever there is a change in this collection say a new data is added, data is removed, data is
                // edited and so on.
                // This builder function will get recalled, and then the wizards inside of it will get rebuilt.
                // So we do not have to use set state for displaying the changes in the stream, and this snapshot callback
                // value of this builder function will hold the updated data of the stream.
                //SET UP 1 SB VỚI STREAM LÀ CÁI TRƯỜNG MÌNH CẦN NGHE CÁI SỰ THAY ĐỔI CỦA DATA IN REALTIME
                StreamBuilder(
                  stream: db
                      .collection("messages")
                      .where(
                        "chatroom_id",
                        isEqualTo: widget.chatroomId,
                      ) //query specific box chat by using where id match with current chat room id
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  //orderby để sắp xếp thứ tự tin nhắn theo thời gian thực
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      //NHỚ KĨ DÒNG NÀY KHI THAO TÁC VỚI STREAMBUILDER
                      print(
                        "Snapshot error: ${snapshot.error}",
                      ); // <-- In chi tiết lỗi ra debug console
                      return Text(
                        "Đã xảy ra lỗi khi tải tin nhắn.",
                      ); // <-- Hiển thị thông báo dễ hiểu hơn
                    }

                    var allMessages =
                        snapshot.data?.docs ??
                        []; //holding all the messages from this collection

                    if (allMessages.length < 1) {
                      return Center(child: Text("No messages here"));
                    }

                    return ListView.builder(
                      reverse: true, // cho nó nằm dưới
                      itemCount: allMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: singleChatItem(
                            sender_name: allMessages[index]["sender_name"],
                            text: allMessages[index]["text"],
                            sender_id: allMessages[index]["sender_id"],
                          ),
                        );
                      },
                    );
                  },
                ), //
          ),
          Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageText,

                      decoration: InputDecoration(
                        hintText: "Write message here",
                        border: InputBorder
                            .none, //ko có gạch dưới trong ô textfiled
                      ),
                    ),
                  ),
                  InkWell(onTap: sendMessage, child: Icon(Icons.send)),
                ],
              ),
            ),
          ),
        ],
      ), //want load title of the chat room as a title of this scaffold
    );
  }
}
