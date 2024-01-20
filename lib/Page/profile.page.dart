import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiFriend.dart';
import 'package:projectbdtravel/API/apiPost.dart';
import 'package:projectbdtravel/API/apiUser.dart';
import 'package:projectbdtravel/Page/detailPlace.page.dart';
import 'package:projectbdtravel/Page/timeline.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:projectbdtravel/Tools/style.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class Profile extends StatefulWidget {
  final String id;
  final String? info;
  const Profile({Key? key, required this.id, required this.info})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SampleItem? selectedMenu;

  List data = [];
  String id = '';
  String img = '';
  String name = '';
  String name_o = '';
  String img_o = '';
  String status = '';

  @override
  void initState() {
    // TODO: implement initState
    getProfile();
    getMe();
    getother();
    super.initState();
  }

  Future<List> getProfile() async {
    try {
      data = await Profile_info(widget.id);
    } catch (e) {
      print(e);
    }
    print(data);
    return data;
  }

  getMe() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      id = _prefs.getString('id').toString();
      name = '${_prefs.getString('fName')} ${_prefs.getString('lName')}';
      img = _prefs.getString('image').toString();
    });
  }

  getother() async {
    var data = await getDetailMember(widget.id);
    setState(() {
      name_o = '${data[0]['M_fName']} ${data[0]['M_lName']}';
      img_o = data[0]['M_Image'].toString();
    });
    TextEditingController str = new TextEditingController();
    setState(() {
      str.text = widget.id;
    });
    var response = await search_friend(id, str);
    if (response['status'] == '0') {
      setState(() {
        status = 'friend';
      });
    } else if (response['status'] == '2') {
      setState(() {
        status = '2';
      });
    }
  }

  Future<void> _showMyDialogDeleteCheckin(String cid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ต้องการลบการเช็คอินออกใช่หรือไม่'),
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
                        String value = await delete_Checkin("remove", cid);
                        if (value == "TRUE") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ลบข้อมูลสำเร็จ')));
                          setState(() {
                            Profile_info(widget.id);
                          });
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('ลบข้อมูลไม่สำเร็จ')));
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

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: h * 1.1,
          width: w,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              HexColor('#615EFF'),
              HexColor('#4D615FFF'),
            ],
          )),
          child: Column(
            children: [
              Container(
                width: w,
                height: h * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(140, 255, 255, 255)),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context, 'TRUE');
                            },
                            icon: Icon(Icons.arrow_back)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: widget.info == 'me' ||
                              widget.info == 'friend' ||
                              status == 'friend'
                          ? null
                          : status == '2'
                              ? Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Color.fromARGB(140, 255, 255, 255)),
                                  child: IconButton(
                                      onPressed: () async {
                                        String value =
                                            await cancel_Friend(widget.id, id);
                                        if (value == "TRUE") {
                                          setState(() {
                                            status = "other";
                                          });
                                        }
                                      },
                                      icon: Icon(Icons.person_remove_alt_1)),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Color.fromARGB(140, 255, 255, 255)),
                                  child: IconButton(
                                      onPressed: () async {
                                        var data =
                                            await addFriend(id, widget.id);
                                        if (data == "TRUE") {
                                          setState(() {
                                            status = '2';
                                          });
                                        } else if (data == "FRIEND") {
                                          setState(() {
                                            status = 'friend';
                                          });
                                        }
                                      },
                                      icon: Icon(Icons.person_add)),
                                ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.01),
              Container(
                width: w,
                height: 0.25 * h,
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(color: Colors.white38),
                // decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: w * 0.325,
                        height: h * 0.185,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.info == 'me' ? img : img_o,
                              ),
                              fit: BoxFit.fill,
                            )),
                      ),
                      Container(
                        width: w * 0.5,
                        height: h * 0.25,
                        alignment: Alignment.centerLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.info == 'me' ? name : name_o,
                                style: styleText.styleNameProfile,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'ID : ' + widget.id,
                                style: styleText.styleIDProfile,
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          bottom: BorderSide(width: 1, color: Colors.black))),
                ),
              ),
              Expanded(
                  child: FutureBuilder(
                      future: getProfile(),
                      builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        if (ConnectionState.active != null &&
                            !snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder:
                                (BuildContext buildContext, int index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(
                                                    data[index]
                                                        ['Profile_Image'],
                                                    scale: 1.0),
                                              ),
                                            ),
                                            Wrap(
                                              direction: Axis.vertical,
                                              spacing: 2,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: w * 0.6,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            data[index]['Profile_Name']
                                                                        .toString()
                                                                        .length >
                                                                    14
                                                                ? data[index][
                                                                            'Profile_Name']
                                                                        .substring(
                                                                            0,
                                                                            10) +
                                                                    '...'
                                                                : data[index][
                                                                    'Profile_Name'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Icon(
                                                            Icons.location_on,
                                                            color:
                                                                Colors.black38,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          DetailPlace(
                                                                              id: data[index]['P_ID'])));
                                                            },
                                                            child: Text(data[index][
                                                                            'Place_Name']
                                                                        .toString()
                                                                        .length >
                                                                    10
                                                                ? data[index][
                                                                            'Place_Name']
                                                                        .substring(
                                                                            0,
                                                                            10) +
                                                                    '...'
                                                                : data[index][
                                                                    'Place_Name']),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    widget.info == 'me'
                                                        ? Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            132,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                            child:
                                                                PopupMenuButton<
                                                                    SampleItem>(
                                                              initialValue:
                                                                  selectedMenu,
                                                              // Callback that sets the selected popup menu item.
                                                              onSelected:
                                                                  (SampleItem
                                                                      item) async {
                                                                setState(() {
                                                                  selectedMenu =
                                                                      item;
                                                                });
                                                                if (selectedMenu ==
                                                                    SampleItem
                                                                        .itemTwo) {
                                                                  _showMyDialogDeleteCheckin(
                                                                      data[index]
                                                                          [
                                                                          'C_ID']);
                                                                } else if (selectedMenu ==
                                                                    SampleItem
                                                                        .itemOne) {
                                                                  String value = await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              EditCheckin(cid: data[index]['C_ID'])));
                                                                  if (value ==
                                                                      "TRUE") {
                                                                    setState(
                                                                        () {
                                                                      getProfile();
                                                                    });
                                                                  }
                                                                }else if(selectedMenu == SampleItem.itemThree){

                                                                }
                                                              },
                                                              itemBuilder: (BuildContext
                                                                      context) =>
                                                                  <PopupMenuEntry<
                                                                      SampleItem>>[
                                                                const PopupMenuItem<
                                                                    SampleItem>(
                                                                  value: SampleItem
                                                                      .itemOne,
                                                                  child: Text(
                                                                    'แก้ไข',
                                                                  ),
                                                                ),
                                                                const PopupMenuItem<
                                                                    SampleItem>(
                                                                  value: SampleItem
                                                                      .itemTwo,
                                                                  child: Text(
                                                                    'ลบ',
                                                                  ),
                                                                ),
                                                                const PopupMenuItem<
                                                                    SampleItem>(
                                                                  value: SampleItem
                                                                      .itemThree,
                                                                  child: Text(
                                                                    'แชร์ Facebook',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                                Container(
                                                    width: w * 0.6,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Expanded(
                                                        child: Text(
                                                      '${data[index]['C_Text']}',
                                                    )))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          width: w * 0.65,
                                          height:
                                              data[index]['C_Image'].length == 0
                                                  ? 0
                                                  : h * 0.165,
                                          child: Scrollbar(
                                            showTrackOnHover: true,
                                            child: PageView.builder(
                                                itemCount: data[index]
                                                        ['C_Image']
                                                    .length,
                                                pageSnapping: true,
                                                padEnds: false,
                                                itemBuilder: (context, i) {
                                                  return Container(
                                                      child: Image.network(
                                                    data[index]['C_Image'][i],
                                                    fit: BoxFit.fitHeight,
                                                  ));
                                                }),
                                          )),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(top: 5),
                                        width: w * 0.65,
                                        child: Text(
                                          'วันที่ ' +
                                              data[index]['date'].toString(),
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                      SizedBox(height: 10,)
                                    ],
                                  ),
                                ),
                              );
                            });
                      })),
            ],
          ),
        ),
      )),
    );
  }
}
