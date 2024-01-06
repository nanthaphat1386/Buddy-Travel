import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/Page/listFavorite.page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class timeline extends StatefulWidget {
  const timeline({super.key});

  @override
  State<timeline> createState() => _timelineState();
}

class _timelineState extends State<timeline> {
  String ID = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        ID = prefs.getString('id').toString();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#9C9AFC'),
        title: Text("ไทมไลน์"),
        actions: [
          IconButton(
            onPressed: () async {
              String value = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => List_Favorite(id: ID,)));
              if (value == "TRUE") {
              } else {}
            },
            icon: Icon(Icons.bookmark),
            tooltip: 'รายการที่ชอบ',
          )
        ],
      ),
    );
  }
}
