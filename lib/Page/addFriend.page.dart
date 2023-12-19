import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiUser.dart';
import 'package:projectbdtravel/Page/profile.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  TextEditingController id_search = new TextEditingController();
  int search = 0;
  String name = '';
  String id = '';
  String img = '';

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, 'TRUE');
            },
            icon: Icon(Icons.arrow_back)),
        title: Text('เพิ่มเพื่อน'),
        backgroundColor: HexColor('#9C9AFC'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: h * 0.015),
            Container(
              width: w,
              padding: EdgeInsets.all(10),
              height: h * 0.1,
              child: TextField(
                controller: id_search,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: HexColor('#9C9AFC')),
                        borderRadius: BorderRadius.circular(20)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: HexColor('#9C9AFC')),
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'ค้นหาเพื่อน',
                    suffixIcon: InkWell(
                      onTap: () async {
                        if (id_search.text.isEmpty) {
                          setState(() {
                            name = '';
                            id = '';
                            img = '';
                          });
                        } else {
                          var data = await Search_Friend(id_search.text);
                          if (data != "FALSE") {
                            setState(() {
                              name = '${data[0]['M_fName']} ${data[0]['M_lName']}';
                              id = data[0]['M_ID'].toString();
                              img = data[0]['M_Image'].toString();
                            });
                          } else {
                            setState(() {
                              name = '';
                              id = '';
                              img = '';
                            });
                          }
                        }
                        print(search);
                      },
                      child: Icon(
                        Icons.search,
                        color: HexColor('#9C9AFC'),
                      ),
                    )),
              ),
            ),
            Container(
              width: w,
              child: name == ''
                  ? null
                  : Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(id: id, info: 'other',),));
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(img, scale: 1.0),
                        ),
                        title: Text(name),
                        subtitle: Text('ID : ' + id),
                        trailing: InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.person_add_alt,
                              color: HexColor('#0377FF'),
                            )),
                      ),
                    ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.topLeft,
              child: Text('คำขอเป็นเพื่อน'),
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: search == 1 ? h * 0.655 : h * 0.8,
              child: ListView(),
            ),
          ],
        ),
      )),
    );
  }
}
