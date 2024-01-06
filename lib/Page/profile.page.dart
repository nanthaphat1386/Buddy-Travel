import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiFriend.dart';
import 'package:projectbdtravel/API/apiUser.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:projectbdtravel/Tools/style.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String id;
  final String? info;
  const Profile({Key? key, required this.id, required this.info})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                // decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: w * 0.35,
                        height: h * 0.2,
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
                                                    Text(
                                                      data[index]
                                                          ['Profile_Name'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.black38,
                                                        ),
                                                        Text(data[index]
                                                            ['Place_Name'])
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: w * 0.1,
                                                    ),
                                                    widget.info == 'me'
                                                        ? IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(Icons
                                                                .edit_note))
                                                        : Container(),
                                                  ],
                                                ),
                                                Container(
                                                    width: w * 0.6,
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
                                          height: h * 0.165,
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
                                                    fit: BoxFit.fill,
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
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: w * 0.8,
                                          height: h * 0.06,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.favorite_outline,
                                                color: HexColor('#615EFF'),
                                              ),
                                              Icon(
                                                Icons.share,
                                                color: HexColor('#615EFF'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
