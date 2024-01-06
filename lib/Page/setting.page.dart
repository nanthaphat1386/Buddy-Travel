import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/Page/edit.page.dart';
import 'package:projectbdtravel/Page/friend.page.dart';
import 'package:projectbdtravel/Page/login.page.dart';
import 'package:projectbdtravel/Page/profile.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:projectbdtravel/Tools/style.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  String name = '';
  String img = '';
  String ID = '';

  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        img = prefs.getString('image').toString();
        ID = prefs.getString('id').toString();
        name = prefs.getString('fName').toString() +
            ' ' +
            prefs.getString('lName').toString();
      });
    } catch (e) {
      print(e);
    }
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Color.fromARGB(167, 81, 69, 250),
      Color.fromARGB(255, 81, 69, 250)
    ],
  ).createShader(Rect.fromLTWH(50.0, 0.0, 200.0, 0.0));

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    Column selectButton() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
            Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile(id: ID,info: 'me',)));
            },
            child: Card(
              color: HexColor('#9C9AFC'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(
                  'ข้อมูลโปรไฟล์',
                  style: styleText.select_button_white,
                ),
                trailing: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              String value = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile()));
              if (value == 'true') {
                getProfile();
              } else {}
            },
            child: Card(
              color: HexColor('#9C9AFC'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(
                  'แก้ไขข้อมูลส่วนตัว',
                  style: styleText.select_button_white,
                ),
                trailing: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              String value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const EditPassword())));
              if (value.contains('TRUE')) {
                getProfile();
              }
            },
            child: Card(
              color: HexColor('#9C9AFC'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(
                  'แก้ไขรหัสผ่าน',
                  style: styleText.select_button_white,
                ),
                trailing: Icon(
                  Icons.key,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Logout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            },
            child: Card(
              color: HexColor('#9C9AFC'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Text(
                  'ออกจากระบบ',
                  style: styleText.select_button_white,
                ),
                trailing: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ตั้งค่า'),
        backgroundColor: HexColor('#9C9AFC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            tooltip: 'เพื่อน',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FriendsPage()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(w * 0.01, h * 0.02, w * 0.01, h * 0.02),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.transparent, width: 3.0)),
                      child: CircleAvatar(
                        radius: w * 0.25,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(img, scale: 1.0),
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: w * 0.075,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Center(
                child: Text(
                  "ID : " + ID,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 15),
              selectButton(),
            ],
          ),
        ),
      ),
    );
  }
}
