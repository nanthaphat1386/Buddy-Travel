import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiFriend.dart';
import 'package:projectbdtravel/Page/profile.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  TextEditingController id_search = new TextEditingController();
  int search = 1;
  String name = '';
  String id = '';
  String img = '';
  String status = '';

  String mid = '';
  List request_friend = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
    allRequest(mid);
  }

  getID() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        mid = prefs.getString('id').toString();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List> allRequest(String id) async {
    try {
      request_friend = await get_Request(id);
    } catch (e) {
      print(e);
    }
    print(request_friend);
    return request_friend;
  }

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
                          var data = await search_friend(mid, id_search);
                          print(data);
                          if (data['id'] == mid && data['id'] != '') {
                            setState(() {
                              name = data['name'];
                              id = data['id'];
                              img = data['image'];
                              status = '3';
                            });
                          } else if (data['id'] != mid && data['id'] != '') {
                            setState(() {
                              name = data['name'];
                              id = data['id'];
                              img = data['image'];
                              status = data['status'];
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
                        onTap: () async {
                          String value = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(
                                  id: id,
                                  info: id == mid ? 'me' : 'other',
                                ),
                              ));
                          if (value == "TRUE") {
                            var data = await search_friend(mid, id_search);
                            if (data != "FALSE") {
                              setState(() {
                                name = data['name'];
                                id = data['id'];
                                img = data['image'];
                                status = data['status'];
                              });
                            }
                            setState(() {
                              allRequest(mid);
                            });
                          }
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(img, scale: 1.0),
                        ),
                        title: Text(name),
                        subtitle: Text('ID : ' + id),
                        trailing: status == '0'
                            ? Text('เป็นเพื่อนกันแล้ว')
                            : status == '1'
                                ? InkWell(
                                    onTap: () async {
                                      var data = await addFriend(mid, id);
                                      if (data == "TRUE") {
                                        setState(() {
                                          status = '2';
                                        });
                                      } else if (data == "FRIEND") {
                                        setState(() {
                                          status = '0';
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.person_add_alt,
                                      color: HexColor('#0377FF'),
                                    ))
                                : status == '2'
                                    ? Text('ส่งคำขอแล้ว')
                                    : null,
                        // InkWell(
                        //     onTap: () {},
                        //     child: Icon(
                        //       Icons.person_add_alt,
                        //       color: HexColor('#0377FF'),
                        //     )),
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
              child: Expanded(
                  child: FutureBuilder(
                      future: allRequest(
                          mid), // a previously-obtained Future<String> or null
                      builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        if (ConnectionState.active != null &&
                            !snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                          itemCount: request_friend.length,
                          itemBuilder: (BuildContext buildContext, int index) {
                            return Card(
                              child: ListTile(
                                  onTap: () async {
                                    String value = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Profile(
                                            id: request_friend[index]['Fr_ID'],
                                            info: 'other',
                                          ),
                                        ));
                                    if (value == "TRUE") {
                                      setState(() {
                                        allRequest(mid);
                                      });
                                    }
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        request_friend[index]['Fr_Image'],
                                        scale: 1.0),
                                  ),
                                  title: Text(request_friend[index]['Fr_Name']),
                                  subtitle: Text(
                                      'ID : ' + request_friend[index]['Fr_ID']),
                                  trailing: Container(
                                    width: w * 0.15,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                            onTap: () async {
                                              String ans = await accept_Friend(
                                                  mid,
                                                  request_friend[index]
                                                      ['Fr_ID']);
                                              if (ans == "TRUE") {
                                                setState(() {
                                                  allRequest(mid);
                                                });
                                              }
                                            },
                                            child: Icon(
                                              Icons.person_add_alt,
                                              color: HexColor('#0377FF'),
                                            )),
                                        InkWell(
                                            onTap: () async {
                                              String ans = await cancel_Friend(
                                                  mid,
                                                  request_friend[index]
                                                      ['Fr_ID']);
                                              if (ans == "TRUE") {
                                                setState(() {
                                                  allRequest(mid);
                                                });
                                              }
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
          ],
        ),
      )),
    );
  }
}
