import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiPost.dart';
import 'package:projectbdtravel/Page/listFavorite.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class timeline extends StatefulWidget {
  const timeline({super.key});

  @override
  State<timeline> createState() => _timelineState();
}

class _timelineState extends State<timeline> {
  String ID = '';
  List checkin = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    getCheckin(ID);
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

  Future<List> getCheckin(String id) async {
    print(id);
    try {
      checkin = await get_ListCheckin(id);
    } catch (e) {
      print(e);
    }
    return checkin;
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor('#9C9AFC'),
          title: Text("ไทมไลน์"),
          actions: [
            IconButton(
              onPressed: () async {
                String value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => List_Favorite(
                              id: ID,
                            )));
                if (value == "TRUE") {
                } else {}
              },
              icon: Icon(Icons.bookmark),
              tooltip: 'รายการที่ชอบ',
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(125, 132, 102, 250)
          ),
          height: h * 1,
          width: w * 1,
          child: Column(children: [
            Expanded(
                child: FutureBuilder(
                    future: getCheckin(
                        ID), // a previously-obtained Future<String> or null
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (ConnectionState.active != null && !snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Scrollbar(
                          child: ListView.builder(
                              itemCount: checkin.length,
                              itemBuilder:
                                  (BuildContext buildContext, int index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Container(
                                    width: w * 0.9,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                                      checkin[index]['P_image'],
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        checkin[index]['name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.location_on,
                                                            color:
                                                                Colors.black38,
                                                          ),
                                                          Text(checkin[index]
                                                              ['P_name'])
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: w * 0.1,
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                      width: w * 0.6,
                                                      child: Expanded(
                                                          child: Text(
                                                        '${checkin[index]['text']}',
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
                                                  itemCount: checkin[index]
                                                          ['image']
                                                      .length,
                                                  pageSnapping: true,
                                                  padEnds: false,
                                                  itemBuilder: (context, i) {
                                                    return Container(
                                                        child: Image.network(
                                                      checkin[index]['image']
                                                          [i],
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
                                                checkin[index]['date']
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black54),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                              }));
                    }))
          ]),
        ));
  }
}
