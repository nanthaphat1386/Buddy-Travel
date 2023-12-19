import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/Page/addFriend.page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพื่อน'),
        backgroundColor: HexColor('#9C9AFC'),
        actions: [
          IconButton(
              onPressed: () async {
                String value = await Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => AddFriend())));
                if (value == 'TRUE') {
                  
                }
              },
              icon: Icon(Icons.person_add))
        ],
      ),
    );
  }
}
