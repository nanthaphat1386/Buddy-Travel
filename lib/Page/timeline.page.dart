import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectbdtravel/API/apiPost.dart';
import 'package:projectbdtravel/Page/detailPlace.page.dart';
import 'package:projectbdtravel/Page/listFavorite.page.dart';
import 'package:projectbdtravel/Page/profile.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class timeline extends StatefulWidget {
  const timeline({super.key});

  @override
  State<timeline> createState() => _timelineState();
}

class _timelineState extends State<timeline> {
  String ID = '';
  List checkin = [];

  SampleItem? selectedMenu;

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
    getCheckin(ID);
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
                            getCheckin(ID);
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
          decoration: BoxDecoration(color: Color.fromARGB(125, 132, 102, 250)),
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
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
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
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: ((context) => Profile(
                                                                  id: checkin[
                                                                          index]
                                                                      ["M_ID"],
                                                                  info: ID ==
                                                                          checkin[index]
                                                                              [
                                                                              "M_ID"]
                                                                      ? "me"
                                                                      : "friend"))));
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              checkin[index]
                                                                  ['P_image'],
                                                              scale: 1.0),
                                                    ),
                                                  )),
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
                                                      Container(
                                                        width: w * 0.625,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: ((context) => Profile(
                                                                            id: checkin[index][
                                                                                "M_ID"],
                                                                            info: ID == checkin[index]["M_ID"]
                                                                                ? "me"
                                                                                : "friend"))));
                                                              },
                                                              child: Text(
                                                                checkin[index]['name']
                                                                            .toString()
                                                                            .length >
                                                                        14
                                                                    ? checkin[index]['name'].substring(
                                                                            0,
                                                                            10) +
                                                                        '...'
                                                                    : checkin[
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons.location_on,
                                                              color: Colors
                                                                  .black38,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                DetailPlace(id: checkin[index]['P_ID'])));
                                                              },
                                                              child: Text(checkin[
                                                                                  index]
                                                                              [
                                                                              'P_name']
                                                                          .toString()
                                                                          .length >
                                                                      10
                                                                  ? checkin[index]
                                                                              [
                                                                              'P_name']
                                                                          .substring(
                                                                              0,
                                                                              10) +
                                                                      '...'
                                                                  : checkin[
                                                                          index]
                                                                      [
                                                                      'P_name']),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      ID ==
                                                              checkin[index]
                                                                  ["M_ID"]
                                                          ? Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              width: w * 0.1,
                                                              child: InkWell(
                                                                onTap: () {},
                                                                child: PopupMenuButton<
                                                                    SampleItem>(
                                                                  initialValue:
                                                                      selectedMenu,
                                                                  // Callback that sets the selected popup menu item.
                                                                  onSelected:
                                                                      (SampleItem
                                                                          item) async {
                                                                    setState(
                                                                        () {
                                                                      selectedMenu =
                                                                          item;
                                                                    });
                                                                    if (selectedMenu ==
                                                                        SampleItem
                                                                            .itemTwo) {
                                                                      _showMyDialogDeleteCheckin(
                                                                          checkin[index]
                                                                              [
                                                                              'C_ID']);
                                                                    } else if (selectedMenu ==
                                                                        SampleItem
                                                                            .itemOne) {
                                                                      String value = await Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => EditCheckin(cid: checkin[index]['C_ID'])));
                                                                      if (value ==
                                                                          "TRUE") {
                                                                        setState(
                                                                            () {
                                                                          getCheckin(
                                                                              ID);
                                                                        });
                                                                      }
                                                                    } else if (selectedMenu ==
                                                                        SampleItem
                                                                            .itemThree) {}
                                                                  },
                                                                  itemBuilder: (BuildContext
                                                                          context) =>
                                                                      <PopupMenuEntry<
                                                                          SampleItem>>[
                                                                    const PopupMenuItem<
                                                                        SampleItem>(
                                                                      value: SampleItem
                                                                          .itemOne,
                                                                      child:
                                                                          Text(
                                                                        'แก้ไข',
                                                                      ),
                                                                    ),
                                                                    const PopupMenuItem<
                                                                        SampleItem>(
                                                                      value: SampleItem
                                                                          .itemTwo,
                                                                      child:
                                                                          Text(
                                                                        'ลบ',
                                                                      ),
                                                                    ),
                                                                    const PopupMenuItem<
                                                                        SampleItem>(
                                                                      value: SampleItem
                                                                          .itemThree,
                                                                      child:
                                                                          Text(
                                                                        'แชร์ลง Facebook',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : Container()
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
                                            height: checkin[index]['image']
                                                        .length !=
                                                    0
                                                ? h * 0.165
                                                : 0,
                                            child: Scrollbar(
                                              child: PageView.builder(
                                                  itemCount: checkin[index]
                                                          ['image']
                                                      .length,
                                                  pageSnapping: true,
                                                  padEnds: false,
                                                  itemBuilder: (context, i) {
                                                    return checkin[index]
                                                                    ['image']
                                                                .length !=
                                                            0
                                                        ? Container(
                                                            child:
                                                                Image.network(
                                                            checkin[index]
                                                                ['image'][i],
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          ))
                                                        : Container();
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
                                        SizedBox(
                                          height: 10,
                                        )
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

class EditCheckin extends StatefulWidget {
  final String cid;
  const EditCheckin({Key? key, required this.cid}) : super(key: key);

  @override
  State<EditCheckin> createState() => _EditCheckinState();
}

class _EditCheckinState extends State<EditCheckin> {
  String str = '';
  List data = [];
  TextEditingController text = new TextEditingController();

  List imageFileList = [];
  List<XFile>? imageFileListAdd = [];
  final ImagePicker imagePicker = ImagePicker();

  @override
  initState() {
    super.initState();
    getDataCheckin(widget.cid);
  }

  Future<List<dynamic>> getDataCheckin(String cid) async {
    try {
      var ans = await get_CheckinByID(cid);
      data.add(ans);
      text.text = ans['C_Text'];
      setState(() {
        imageFileList = ans['C_Image'];
      });
    } catch (e) {
      print("error");
    }

    print(imageFileList);

    return data;
  }

  void selectImages() async {
    if (imageFileList!.length == 5) {
      _dialogBuilderFullImage(context);
    } else {
      try {
        final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
        if (selectedImages!.isNotEmpty) {
          for (int i = 0; i < selectedImages.length; i++) {
            imageFileList!.add(selectedImages[i]);
          }
        }
        setState(() {});
      } catch (e) {}
    }
  }

  Future<void> _dialogBuilderFullImage(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คำเตือน'),
          content: const Text(
              'รูปภาพครบ 5 รูปแล้ว โปรดลบออกแล้วทำรายการใหม่อีกครั้ง'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
        title: Text('แก้ไขข้อมูลการเช็คอิน'),
        backgroundColor: HexColor('#9C9AFC'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, "FALSE");
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
          width: w * 1,
          height: h * 1.1,
          // decoration: BoxDecoration(color: Colors.black12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: h * 0.025,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: text,
                    maxLines: 4,
                    // controller: text,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      filled: true,
                      fillColor: Colors.transparent,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Color.fromARGB(255, 81, 69, 250)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Color.fromARGB(255, 81, 69, 250)),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: w * 0.945,
                          height: h * 0.13,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromARGB(255, 81, 69, 250))),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                                crossAxisCount: 5,
                              ),
                              itemCount: imageFileList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    splashColor: Colors
                                        .white10, // Splash color over image
                                    child: Stack(
                                      children: [
                                        Ink.image(
                                            fit: BoxFit
                                                .cover, // Fixes border issues
                                            width: 100,
                                            height: 80,
                                            image: NetworkImage(
                                                imageFileList[index])),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: InkWell(
                                            onTap: () {
                                              imageFileList.removeAt(index);
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                              },
                            ),
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: h * 0.015,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              selectImages();
                            },
                            child: Text('เพิ่มรูปภาพ'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(167, 81, 69, 250)))),
                        Container(
                          width: w * 0.65,
                          height: h * 0.275,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromARGB(255, 81, 69, 250))),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                                crossAxisCount: 3,
                              ),
                              itemCount: imageFileListAdd!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    splashColor: Colors
                                        .white10, // Splash color over image
                                    child: Stack(
                                      children: [
                                        Ink.image(
                                            fit: BoxFit
                                                .cover, // Fixes border issues
                                            width: 100,
                                            height: 80,
                                            image: FileImage(File(
                                                imageFileListAdd![index]
                                                    .path))),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: InkWell(
                                            onTap: () {
                                              imageFileListAdd!.removeAt(index);
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                              },
                            ),
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: h * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: w * 1,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        String images = imageFileList
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", "");
                        String images_new = imageFileListAdd!
                            .map<String>((xfile) => xfile.name)
                            .toList()
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", "");
                        String value = await edit_Checkin(
                            "edit",
                            widget.cid,
                            text,
                            images.isEmpty ? "" : images,
                            images_new.isEmpty ? "" : images_new);
                        if (value == "TRUE") {
                          for (int i = 0; i < imageFileListAdd!.length; i++) {
                            UploadImageCheckin(imageFileListAdd![i].path,
                                imageFileListAdd![i].name);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('แก้ไขสำเร็จ')));
                          Navigator.pop(context, "TRUE");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('แก้ไขไม่สำเร็จ')));
                        }
                      },
                      child: Text("แก้ไขเช็คอินสถานที่"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(167, 81, 69, 250))),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
