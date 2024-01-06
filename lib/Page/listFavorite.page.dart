import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiFavorite.dart';
import 'package:projectbdtravel/Page/addFavorite.page.dart';
import 'package:projectbdtravel/Page/detailPlace.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class List_Favorite extends StatefulWidget {
  final String id;
  const List_Favorite({Key? key, required this.id}) : super(key: key);

  @override
  State<List_Favorite> createState() => _List_FavoriteState();
}

class _List_FavoriteState extends State<List_Favorite> {
  List Favorite = [];
  List<bool> check = [false];
  bool status = false;
  String id = '';
  String name = '';

  void initState() {
    // TODO: implement initState
    super.initState();
    getBool();
    getListFavorite;
  }

  Future<List> getListFavorite() async {
    Favorite = await get_ListFavorite(widget.id);
    return Favorite;
  }

  Future getBool() async {
    try {
      for (int i = 0; i < 100; i++) {
        check.add(false);
      }
    } catch (e) {}
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('แก้ไขชื่อรายการ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('กรุณากรอกชื่อรายการ'),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 189, 124, 246))),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 189, 124, 246))),
                    labelText: 'ชื่อรายการ',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () async {
                String value = await edit_name_ListFavorite(id, name);
                if (value == "TRUE") {
                  setState(() {
                    getListFavorite();
                  });
                }

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'ยกเลิก',
                style: TextStyle(color: Colors.red.shade300),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ต้องการลบออกจากรายการโปรดหรือไม่'),
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
                        String ans = await remove_ListFavorite("R_FAV", id);
                        if (ans == 'TRUE') {
                          setState(() {
                            getListFavorite();
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
        title: Text('รายการโปรด'),
        backgroundColor: HexColor('#9C9AFC'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, "TRUE");
            },
            icon: Icon(Icons.arrow_back_ios)),
        actions: [
          IconButton(
              onPressed: () async {
                String value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const AddFavorite()));
                if (value == 'TRUE') {
                  getListFavorite();
                } else {}
              },
              icon: Icon(Icons.bookmark_add))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          width: w * 1,
          height: h * 1,
          child: Scrollbar(
              child: Column(
            children: [
              SizedBox(
                height: h * 0.015,
              ),
              Container(
                width: w * 1,
                height: h * 0.98,
                child: Expanded(
                    child: FutureBuilder(
                        future:
                            getListFavorite(), // a previously-obtained Future<String> or null
                        builder: (BuildContext context,
                            AsyncSnapshot<List> snapshot) {
                          if (ConnectionState.active != null &&
                              !snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return Scrollbar(
                              child: ListView.builder(
                                  itemCount: Favorite.length,
                                  itemBuilder:
                                      (BuildContext buildContext, int index) {
                                    return Column(
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                color: HexColor('#9C9AFC'),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              )),
                                          child: ListTile(
                                              title: Text(
                                                  Favorite[index]['Fa_Name']),
                                              onTap: () {
                                                setState(() {
                                                  check[index] = !check[index];
                                                });
                                              },
                                              trailing: Container(
                                                width: w * 0.25,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          id = Favorite[index]
                                                              ['Fa_ID'];
                                                        });
                                                        _showMyDialog();
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Color.fromARGB(
                                                            255, 137, 113, 247),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          id = Favorite[index]
                                                              ['Fa_ID'];
                                                        });
                                                        _showMyDialogDelete();
                                                      },
                                                      child: Icon(
                                                        Icons.bookmark_remove,
                                                        color:
                                                            Colors.red.shade300,
                                                      ),
                                                    ),
                                                    Icon(
                                                      check[index] == false
                                                          ? Icons
                                                              .arrow_right_sharp
                                                          : Icons
                                                              .arrow_drop_down_sharp,
                                                      size: w * 0.075,
                                                      color: Colors.black,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        check[index] == true
                                            ? Container(
                                                width: w * 0.9,
                                                child: Card(
                                                  child: Column(children: [
                                                    for (int i = 0;
                                                        i <
                                                            Favorite[index][
                                                                    'listPlace']
                                                                .length;
                                                        i++)
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        child: Container(
                                                          width: w * 1,
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .black12))),
                                                          child: ListTile(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          DetailPlace(
                                                                              id: Favorite[index]['listPlace'][i]['id'])));
                                                            },
                                                            trailing:
                                                                IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      var value = await remove_fav_place(
                                                                          "R_PLACE",
                                                                          Favorite[index]
                                                                              [
                                                                              'Fa_ID'],
                                                                          Favorite[index]['listPlace'][i]
                                                                              [
                                                                              'id']);
                                                                      if (value ==
                                                                          "TRUE") {
                                                                        setState(
                                                                            () {
                                                                          getListFavorite();
                                                                        });
                                                                      }
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .remove_circle,
                                                                      color: Colors
                                                                          .red
                                                                          .shade300,
                                                                    )),
                                                            title: Text(Favorite[
                                                                        index][
                                                                    'listPlace']
                                                                [i]['name']),
                                                            subtitle: Container(
                                                              width: w * 1,
                                                              height: h * 0.25,
                                                              margin: EdgeInsets
                                                                  .fromLTRB(
                                                                      0,
                                                                      10,
                                                                      0,
                                                                      10),
                                                              child: Column(
                                                                  children: [
                                                                    Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      width:
                                                                          w * 0.75,
                                                                      height: h *
                                                                          0.185,
                                                                      child:
                                                                          Scrollbar(
                                                                        child: PageView.builder(
                                                                            itemCount: Favorite[index]['listPlace'][i]['image'].length,
                                                                            pageSnapping: true,
                                                                            padEnds: false,
                                                                            itemBuilder: (context, pagePosition) {
                                                                              return Container(
                                                                                  child: Image.network(
                                                                                Favorite[index]['listPlace'][i]['image'][pagePosition],
                                                                                fit: BoxFit.fitHeight,
                                                                              ));
                                                                            }),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 15,),
                                                                    Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Icon(Icons.location_on),
                                                                        Text( Favorite[index]['listPlace'][i]['province']),
                                                                      ],
                                                                    )
                                                                  ]),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ]),
                                                ),
                                              )
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              )
                                      ],
                                    );
                                  }));
                        })),
              )
            ],
          )

              // Card(
              //   shape: RoundedRectangleBorder(
              //       side: BorderSide(
              //         width: 1,
              //         color: HexColor('#9C9AFC'),
              //       ),
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(10),
              //       )),
              //   child: ListTile(
              //       title: Text(header),
              //       onTap: () {
              //         setState(() {
              //           status = !status;
              //         });
              //       },
              //       trailing: Container(
              //         width: w * 0.25,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             InkWell(
              //               onTap: () {
              //                 _showMyDialog();
              //               },
              //               child: Icon(
              //                 Icons.edit,
              //                 color: Color.fromARGB(255, 137, 113, 247),
              //               ),
              //             ),
              //             InkWell(
              //               onTap: () {},
              //               child: Icon(
              //                 Icons.bookmark_remove,
              //                 color: Colors.red.shade300,
              //               ),
              //             ),
              //             Icon(
              //               status == false
              //                   ? Icons.arrow_right_sharp
              //                   : Icons.arrow_drop_down_sharp,
              //               size: w * 0.075,
              //               color: Colors.black,
              //             ),
              //           ],
              //         ),
              //       )),
              // )
              ),
        ),
      )),
    );
  }
}
