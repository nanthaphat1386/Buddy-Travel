import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiFriend.dart';
import 'package:projectbdtravel/Page/addFriend.page.dart';
import 'package:projectbdtravel/Page/editfriend.page.dart';
import 'package:projectbdtravel/Page/profile.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List Friend = [];
  String id = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
    friend_list(id);
  }

  getID() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        id = prefs.getString('id').toString();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List> friend_list(String id) async {
    try {
      Friend = await get_Friend(id);
    } catch (e) {
      print(e);
    }
    return Friend;
  }

  Future<void> _showMyDialogDelete(String fr_id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ต้องการลบออกจากรายการเพื่อนหรือไม่'),
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
                        String ans = await remove_Friend(id, fr_id);
                        if (ans == 'TRUE') {
                          setState(() {
                            friend_list(id);
                          });
                        }
                        Navigator.pop(context);
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
                  setState(() {
                    friend_list(id);
                  });
                } else {}
              },
              icon: Icon(Icons.person_add))
        ],
      ),
      body: Container(
        height: h * 1.1,
        width: w * 1,
        child: Expanded(
            child: FutureBuilder(
                future: friend_list(
                    id), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (ConnectionState.active != null && !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: Friend.length,
                    itemBuilder: (BuildContext buildContext, int index) {
                      return Card(
                        child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Profile(
                                      id: Friend[index]['FR_ID'],
                                      info: 'friend',
                                    ),
                                  ));
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  Friend[index]['FR_Image'],
                                  scale: 1.0),
                            ),
                            title: Text(Friend[index]['FR_Name']),
                            subtitle: Text('ID : ' + Friend[index]['FR_ID']),
                            trailing: Container(
                              width: w * 0.15,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        String value = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    EditFriend(
                                                      id: id,
                                                      id_friend: Friend[index]
                                                          ['FR_ID'],
                                                      name: Friend[index]
                                                          ['FR_Name'],
                                                    ))));
                                        if (value == "TRUE") {
                                          setState(() {
                                            friend_list(id);
                                          });
                                        } else {
                                          setState(() {
                                            friend_list(id);
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: HexColor('#0377FF'),
                                      )),
                                  InkWell(
                                      onTap: () {
                                        _showMyDialogDelete(
                                            Friend[index]['FR_ID']);
                                      },
                                      child: Icon(
                                        Icons.person_remove_alt_1,
                                        color: Colors.red.shade300,
                                      )),
                                ],
                              ),
                            )),
                      );
                    },
                  );
                })),
      ),
    );
  }
}
