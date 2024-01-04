import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiFriend.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:projectbdtravel/Tools/style.tools.dart';

class EditFriend extends StatefulWidget {
  final String id;
  final String id_friend;
  final String name;
  const EditFriend(
      {Key? key, required this.id, required this.id_friend, required this.name})
      : super(key: key);

  @override
  State<EditFriend> createState() => _EditFriendState();
}

class _EditFriendState extends State<EditFriend> {
  TextEditingController change_name = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _showMyDialogDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันข้อมูล'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ต้องการเปลี่ยนชื่อเพื่อนใช่หรือไม่'),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 127, 97, 248))),
                      onPressed: () async {
                        String ans = await change_Friend(
                            widget.id, widget.id_friend, change_name);
                        if (ans == "TRUE") {
                          Navigator.pop(context);
                          Navigator.pop(context, "TRUE");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('แก้ไขไม่สำเร็จ')));
                          Navigator.pop(context);
                        }
                      },
                      child: Text('ยืนยัน')),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text('ยกเลิก')),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    Padding myTextField(
        String header, String str, IconData icon, TextEditingController text) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, h * 0.01, 0, h * 0.01),
        child: SizedBox(
          width: w * 0.7,
          height: h * 0.07,
          child: TextField(
            controller: text,
            decoration: InputDecoration(
              prefixIcon: Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    icon,
                    color: Color.fromARGB(255, 81, 69, 250),
                  )),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 81, 69, 250), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 81, 69, 250)),
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: header,
              hintText: str,
              labelStyle: TextStyle(color: Color.fromARGB(255, 81, 69, 250)),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(130, 81, 69, 250),
                Color.fromARGB(180, 81, 69, 250),
              ],
            )),
            width: w,
            height: h * 1.2,
            padding: EdgeInsets.fromLTRB(0, h * 0.055, 0, 0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: w * 0.1,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context, 'FALSE');
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(w * 0.03),
                      child: Text(
                        'แก้ไขชื่อเพื่อน',
                        style: styleText.EditHeaderText,
                      ),
                    ),
                  ),
                  Container(
                    width: w * 0.85,
                    margin: EdgeInsets.fromLTRB(
                        w * 0.1, h * 0.025, w * 0.1, h * 0.045),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.fromLTRB(0, h * 0.025, 0, h * 0.025),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          myTextField(
                              'ชื่อ', widget.name, Icons.person, change_name),
                          ButtonTheme(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(167, 81, 69, 250)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                              ),
                              onPressed: () async {
                                _showMyDialogDelete();
                              },
                              child: const Text(
                                "ยืนยันการแก้ไข",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ]))));
  }
}
