import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectbdtravel/API/apiFavorite.dart';
import 'package:projectbdtravel/API/apiPlace.dart';
import 'package:projectbdtravel/API/apiPost.dart';
import 'package:projectbdtravel/API/apiReview.dart';
import 'package:projectbdtravel/Page/addPlace.page.dart';
import 'package:projectbdtravel/Page/editPlace.page.dart';
import 'package:projectbdtravel/Page/history.page.dart';
import 'package:projectbdtravel/Page/profile.page.dart';
import 'package:projectbdtravel/Page/review.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class DetailPlace extends StatefulWidget {
  final String id;
  const DetailPlace({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPlace> createState() => _DetailPlaceState();
}

class _DetailPlaceState extends State<DetailPlace>
    with AutomaticKeepAliveClientMixin<DetailPlace> {
  var detail;
  List? reviews = [];
  SampleItem? selectedMenu;
  String closeplace = '';
  String id_me = '';
  List<XFile>? imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();

  List dropdownFavorite = [];
  List<String> dropdownFavoriteName = [];
  String select = '';
  String select_id = '';

  late GoogleMapController _controller;
  LatLng initialCameraPosition = LatLng(16.2250267, 103.2298629);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetailPlace();
    getReviewPlace();
    getME();
  }

  Future getlistDD(String id) async {
    var data = await dropdown_Favorite(id);
    if (data == "FASLE") {
      dropdownFavorite.clear();
      dropdownFavoriteName.clear();
    } else {
      try {
        dropdownFavorite = data;
        setState(() {
          select_id = dropdownFavorite[0]['id'];
        });

        for (int i = 0; i < data.length; i++) {
          dropdownFavoriteName.add(data[i]['name']);
        }
      } catch (e) {}
    }
    return dropdownFavoriteName;
  }

  Future<List> getDetailPlace() async {
    try {
      detail = await getPlaceID(widget.id);
      double lati = double.parse(detail[0]['P_Lat']);
      double long = double.parse(detail[0]['P_Lng']);
      initialCameraPosition = LatLng(lati, long);
      _onMapCreate(_controller);
    } catch (e) {
      print(e);
    }
    return detail;
  }

  Future<List> getReviewPlace() async {
    try {
      reviews = await get_Review(widget.id);
    } catch (e) {
      print(e);
    }
    return reviews!;
  }

  getME() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      id_me = _prefs.getString('id').toString();
    });
    getlistDD(id_me);
  }

  void _onMapCreate(GoogleMapController controller) {
    try {
      _controller = controller;
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: initialCameraPosition, zoom: 15)));
    } catch (e) {}

    //setMarkers(initialCameraPosition.latitude, initialCameraPosition.longitude);
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

  Future<void> _dialogBuilderDropdown(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คำเตือน'),
          content: const Text(
              'ยังไม่มีชื่อรายการโปรด กรุณาเพิ่มแล้วลองใหม่อีกครั้ง'),
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
                Text('ต้องการปิดการใช้งานสถานที่ท่องเที่ยวแห่งนี้หรือไม่'),
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
                        setState(() {
                          closeplace = 'TRUE';
                        });
                        String process = await closePlace(detail[0]['P_ID']);
                        if (process == 'TRUE') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('ปิดสถานที่ท่องเที่ยวสำเร็จ')));
                          Navigator.pop(context);
                          Navigator.pop(context, 'TRUE');
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text('ตกลง')),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                      onPressed: () async {
                        setState(() {
                          closeplace == 'FALSE';
                        });
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

  Future<void> _showMyDialogDeleteReview(String rid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ต้องการลบการรีวิวนี้ออกใช่หรือไม่'),
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
                        String value = await remove_Review("remove", rid);
                        if (value == "TRUE") {
                          setState(() {
                            getReviewPlace();
                            getDetailPlace();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('ลบการรีวิวสำเร็จ')));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('ไม่สามารถทำรายการได้')));
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

  DropdownMenu dd_Favorite() {
    return DropdownMenu<String>(
      initialSelection: dropdownFavoriteName.first,
      onSelected: (String? value) {
        for (int i = 0; i < dropdownFavorite.length; i++) {
          if (value == dropdownFavorite[i]['name']) {
            setState(() {
              select_id = dropdownFavorite[i]['id'];
            });
          }
        }
        // This is called when the user selects an item.
        setState(() {
          select = value!;
        });
      },
      width: 230,
      dropdownMenuEntries:
          dropdownFavoriteName.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }

  Future<void> _showMyDialogSelect() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เพิ่มลงในรายการโปรด'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('เลือกชื่อรายการที่จะเพิ่ม :'),
                dd_Favorite(),
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
                        String value = await add_PlaceFavorite(
                            "ADD", select_id, widget.id);

                        if (value == "TRUE") {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('เพิ่มรายการสำเร็จ')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('เพิ่มรายการไม่สำเร็จ')));
                        }
                      },
                      child: Text('ตกลง')),
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
        body: Container(
            width: w * 1,
            height: h * 1.2,
            child: Expanded(
                child: FutureBuilder(
                    future: getDetailPlace(),
                    builder:
                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (ConnectionState.active != null && !snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Scrollbar(
                        child: ListView(
                          children: [
                            Container(
                              height: 0.4 * h,
                              width: w,
                              child: Stack(
                                children: [
                                  Scrollbar(
                                    child: PageView.builder(
                                        itemCount: detail[0]['P_Image'].length,
                                        pageSnapping: true,
                                        padEnds: false,
                                        itemBuilder: (context, pagePosition) {
                                          return Container(
                                              child: Image.network(
                                            detail[0]['P_Image'][pagePosition],
                                            fit: BoxFit.fitHeight,
                                          ));
                                        }),
                                  ),
                                  Positioned(
                                    left: w * 0.02,
                                    top: h * 0.02,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              150, 255, 255, 255)),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'FALSE');
                                        },
                                        icon: Icon(Icons.arrow_back_ios_new,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: w * 0.18,
                                    top: h * 0.02,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              132, 255, 255, 255)),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.share,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: w * 0.02,
                                    top: h * 0.02,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              132, 255, 255, 255)),
                                      child: PopupMenuButton<SampleItem>(
                                        initialValue: selectedMenu,
                                        // Callback that sets the selected popup menu item.
                                        onSelected: (SampleItem item) async {
                                          setState(() {
                                            selectedMenu = item;
                                          });
                                          print(selectedMenu.toString());

                                          if (selectedMenu ==
                                              SampleItem.itemThree) {
                                            _showMyDialogDelete();
                                          } else if (selectedMenu ==
                                              SampleItem.itemOne) {
                                            String value = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditPlace(id: widget.id,)));
                                                        if(value == "TRUE"){
                                                          setState(() {
                                                            getDetailPlace();
                                                          });
                                                        }
                                          }else{
                                             Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        History_Place(id: widget.id,)));
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<SampleItem>>[
                                          const PopupMenuItem<SampleItem>(
                                            value: SampleItem.itemOne,
                                            child: Text(
                                              'แก้ไขสถานที่',
                                            ),
                                          ),
                                          const PopupMenuItem<SampleItem>(
                                            value: SampleItem.itemTwo,
                                            child: Text(
                                              'ประวัติการแก้ไข',
                                            ),
                                          ),
                                          const PopupMenuItem<SampleItem>(
                                            value: SampleItem.itemThree,
                                            child: Text(
                                              'ปิดการใช้งานของสถานที่',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: w * 0.025,
                                    right: w * 0.025,
                                    top: h * 0.02,
                                    bottom: h * 0.02),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          detail[0]["P_Name"]
                                                      .toString()
                                                      .length <
                                                  26
                                              ? detail[0]["P_Name"]
                                              : detail[0]["P_Name"]
                                                      .toString()
                                                      .substring(0, 26) +
                                                  "...",
                                          style: TextStyle(
                                              fontSize: w * 0.05,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (dropdownFavoriteName.isEmpty) {
                                              _dialogBuilderDropdown(context);
                                            } else {
                                              _showMyDialogSelect();
                                            }
                                          },
                                          icon: Icon(Icons.bookmark_border,
                                              color: Color.fromARGB(
                                                  122, 116, 63, 238)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        box(detail[0]["P_Point"]),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: w * 0.01),
                                          child: Text(
                                            '( ${detail[0]['P_Review'].length} รีวิว)',
                                            style: TextStyle(
                                                fontSize: w * 0.0375,
                                                color: Color.fromARGB(
                                                    255, 116, 115, 115)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: w * 0.025,
                                  right: w * 0.025,
                                  top: h * 0.01,
                                  bottom: h * 0.01),
                              child: boxDescription(detail[0]["P_Description"]),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                alignment: WrapAlignment.spaceAround,
                                direction: Axis.horizontal,
                                runSpacing: 3,
                                children: [
                                  boxButtonReview(
                                      'เขียนรีวิว',
                                      Icon(
                                        Icons.reviews_sharp,
                                        color: Colors.white,
                                      ),
                                      "REVIEW",
                                      widget.id),
                                  boxButtonAddImage(
                                      'เพิ่มรูป',
                                      Icon(
                                        Icons.camera_enhance,
                                        color: Colors.white,
                                      ),
                                      "IMAGE"),
                                  boxButtonCheckin(
                                    'เช็คอิน',
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                    "CHECKIN",
                                    widget.id,
                                  ),
                                ],
                              ),
                            ),
                            DefaultTabController(
                              length: 2, // length of tabs
                              initialIndex: 0,
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container(
                                      color: Colors.transparent,
                                      child: TabBar(
                                        labelColor: Colors.blueAccent,
                                        unselectedLabelColor: Colors.black,
                                        tabs: [
                                          Tab(text: 'ข้อมูลสถานที่'),
                                          Tab(text: 'การรีวิว'),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        color: Colors.transparent,
                                        height:
                                            h * 0.525, //height of TabBarView
                                        padding: EdgeInsets.only(top: 5),
                                        child: TabBarView(children: <Widget>[
                                          Tab(
                                            child: ListView(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 5, 0, 5),
                                                  height: h * 0.2,
                                                  child: Expanded(
                                                    child: GoogleMap(
                                                      mapType: MapType.normal,
                                                      markers: {
                                                        Marker(
                                                          markerId: MarkerId(
                                                              detail[0]
                                                                  ["P_Name"]),
                                                          position: LatLng(
                                                              initialCameraPosition
                                                                  .latitude,
                                                              initialCameraPosition
                                                                  .longitude),
                                                        ),
                                                      },
                                                      initialCameraPosition:
                                                          CameraPosition(
                                                              target:
                                                                  initialCameraPosition,
                                                              zoom: 14),
                                                      onMapCreated:
                                                          _onMapCreate,
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  child: ListTile(
                                                    leading: Icon(
                                                      Icons.location_on,
                                                      color: Color.fromARGB(
                                                          167, 81, 69, 250),
                                                    ),
                                                    title: Text(
                                                      detail[0]["P_Address"],
                                                      style: TextStyle(
                                                          fontSize: w * 0.035),
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  child: ListTile(
                                                    leading: Icon(
                                                      Icons.home,
                                                      color: Color.fromARGB(
                                                          167, 81, 69, 250),
                                                    ),
                                                    title: Text(
                                                      detail[0]['P_Type']
                                                          .toString()
                                                          .replaceAll('[', '')
                                                          .replaceAll(']', ''),
                                                      style: TextStyle(
                                                          fontSize: w * 0.035),
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  child: ListTile(
                                                    leading: Icon(
                                                      Icons.festival_rounded,
                                                      color: Color.fromARGB(
                                                          167, 81, 69, 250),
                                                    ),
                                                    title: Text(
                                                      detail[0]["P_Festival"]
                                                          .toString()
                                                          .replaceAll('[', '')
                                                          .replaceAll(']', ''),
                                                      style: TextStyle(
                                                          fontSize: w * 0.035),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.all(10))
                                              ],
                                            ),
                                          ),
                                          Tab(
                                            child: Container(
                                              width: 1 * w,
                                              height: h * 0.565,
                                              padding: EdgeInsets.only(
                                                  bottom: 10, top: 5),
                                              child: ListView(
                                                children: [
                                                  for (int i = 0;
                                                      i < reviews!.length;
                                                      i++)
                                                    Container(
                                                        width: w * 1,
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .black12,
                                                                    width:
                                                                        0.5))),
                                                        child: ListTile(
                                                          leading: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => Profile(
                                                                          id: reviews![i]
                                                                              [
                                                                              "R_MID"],
                                                                          info: reviews![i]["R_MID"] == id_me
                                                                              ? "me"
                                                                              : "other")));
                                                            },
                                                            child: CircleAvatar(
                                                              radius: 20,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      reviews![
                                                                              i]
                                                                          [
                                                                          "R_Image"],
                                                                      scale:
                                                                          1.0),
                                                            ),
                                                          ),
                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                  width:
                                                                      w * 0.55,
                                                                  height:
                                                                      h * .03,
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => Profile(id: reviews![i]["R_MID"], info: reviews![i]["R_MID"] == id_me ? "me" : "other")));
                                                                        },
                                                                        child: Text(
                                                                            "${reviews![i]["R_Name"]}  ${reviews![i]["R_Point"]}"),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .star,
                                                                        size: w *
                                                                            0.055,
                                                                        color: Colors
                                                                            .amber,
                                                                      ),
                                                                    ],
                                                                  )),
                                                              id_me ==
                                                                      reviews![
                                                                              i]
                                                                          [
                                                                          "R_MID"]
                                                                  ? Container(
                                                                      width: w *
                                                                          0.2,
                                                                      height: h *
                                                                          0.03,
                                                                      child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () async {
                                                                                String value = await Navigator.push(context, MaterialPageRoute(builder: (builder) => EditReview(rid: reviews![i]["R_ID"])));
                                                                                if (value == "TRUE") {
                                                                                  setState(() {
                                                                                    getReviewPlace();
                                                                                    getDetailPlace();
                                                                                  });
                                                                                } else {}
                                                                              },
                                                                              child: Icon(Icons.edit),
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                print(reviews![i]["R_ID"]);
                                                                                _showMyDialogDeleteReview(reviews![i]["R_ID"]);
                                                                              },
                                                                              child: Icon(Icons.delete),
                                                                            )
                                                                          ]),
                                                                    )
                                                                  : Container()
                                                            ],
                                                          ),
                                                          subtitle: Container(
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    height: reviews![i]["R_Text"].toString().length >
                                                                            80
                                                                        ? h *
                                                                            0.12
                                                                        : reviews![i]["R_Text"].toString().length >
                                                                                40
                                                                            ? h *
                                                                                0.08
                                                                            : h *
                                                                                0.04,
                                                                    child: Text(
                                                                      reviews![
                                                                              i]
                                                                          [
                                                                          "R_Text"],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          height:
                                                                              1.5),
                                                                    ),
                                                                  ),
                                                                  reviews![i]["R_ImageReview"]
                                                                              .length !=
                                                                          0
                                                                      ? Container(
                                                                          height: h *
                                                                              0.09,
                                                                          width: w *
                                                                              0.7,
                                                                          alignment: Alignment
                                                                              .center,
                                                                          child:
                                                                              Expanded(
                                                                            child:
                                                                                GridView.builder(
                                                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                crossAxisSpacing: 1,
                                                                                mainAxisSpacing: 1,
                                                                                crossAxisCount: 5,
                                                                              ),
                                                                              itemCount: reviews![i]["R_ImageReview"].length,
                                                                              itemBuilder: (context, no) {
                                                                                return Stack(
                                                                                  children: [
                                                                                    Image(
                                                                                      fit: BoxFit.fitHeight, // Fixes border issues
                                                                                      width: 75,
                                                                                      height: 75,
                                                                                      image: NetworkImage(reviews![i]["R_ImageReview"][no], scale: 1.0),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ),
                                                                          ))
                                                                      : Container()
                                                                ]),
                                                          ),
                                                        ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]))
                                  ]),
                            ),
                          ],
                        ),
                      );
                    }))));
  }

  Container box(String str) {
    double w = displayWidth(context);
    double h = displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Container(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        //width: 0.15 * w,
        height: 0.075 * h,
        alignment: Alignment.center,
        decoration: myBoxDecoration(Color.fromARGB(137, 116, 63, 238)),
        child: Row(
          children: [
            Text(
              str,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: Colors.white),
            ),
            Icon(
              Icons.star,
              color: Colors.white,
              size: w * 0.0375,
            )
          ],
        ));
  }

  InkWell boxButtonAddImage(String str, Icon icon, String select) {
    double w = displayWidth(context);
    double h = displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return InkWell(
      onTap: () async {
        String value = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddImagePage(
                      pid: widget.id,
                    )));
        if (value == "TRUE") {
          setState(() {
            getDetailPlace();
          });
        } else {}
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          height: 0.13 * h,
          width: 0.275 * w,
          alignment: Alignment.center,
          decoration: myBoxDecoration(Color.fromARGB(122, 116, 63, 238)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              Text(
                ' $str',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.5, color: Colors.white),
              ),
            ],
          )),
    );
  }

  InkWell boxButtonReview(String str, Icon icon, String select, String pid) {
    double w = displayWidth(context);
    double h = displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return InkWell(
      onTap: () async {
        String value = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddReview(
                      pid: pid,
                    )));
        if (value == "TRUE") {
          setState(() {
            getReviewPlace();
            getDetailPlace();
          });
        } else {}
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          height: 0.13 * h,
          width: 0.275 * w,
          alignment: Alignment.center,
          decoration: myBoxDecoration(Color.fromARGB(122, 116, 63, 238)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              Text(
                ' $str',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.5, color: Colors.white),
              ),
            ],
          )),
    );
  }

  InkWell boxButtonCheckin(String str, Icon icon, String select, String pid) {
    double w = displayWidth(context);
    double h = displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return InkWell(
      onTap: () async {
        String value = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddCheckinPage(
                      pid: pid,
                    )));
        if (value == "TRUE") {
        } else {}
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          height: 0.13 * h,
          width: 0.275 * w,
          alignment: Alignment.center,
          decoration: myBoxDecoration(Color.fromARGB(122, 116, 63, 238)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              Text(
                ' $str',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.5, color: Colors.white),
              ),
            ],
          )),
    );
  }

  Container boxDescription(String str) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      alignment: Alignment.topLeft,
      decoration: myBoxDecoration(Color.fromARGB(137, 116, 63, 238)),
      child: Text(
        str,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 13.5, color: Colors.white),
      ),
    );
  }

  BoxDecoration myBoxDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius:
          BorderRadius.all(Radius.circular(5.0) //     <--- border radius here
              ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class AddCheckinPage extends StatefulWidget {
  final String pid;
  const AddCheckinPage({Key? key, required this.pid}) : super(key: key);

  @override
  State<AddCheckinPage> createState() => _AddCheckinPageState();
}

class _AddCheckinPageState extends State<AddCheckinPage> {
  String id = '';
  String name = '';
  String img = '';

  TextEditingController text = new TextEditingController();

  List<XFile>? imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();

  @override
  initState() {
    super.initState();
    getProfile();
  }

  getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        img = prefs.getString('image').toString();
        id = prefs.getString('id').toString();
        name = prefs.getString('fName').toString() +
            ' ' +
            prefs.getString('lName').toString();
      });
    } catch (e) {
      print(e);
    }
  }

  void selectImages() async {
    if (imageFileList!.length == 5) {
      _dialogBuilderFullImage(context);
    } else {
      try {
        final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
        if (selectedImages!.isNotEmpty) {
          imageFileList!.addAll(selectedImages);
        }
        setState(() {});
      } catch (e) {}
    }
  }

  Future uploadImage() async {
    try {
      for (int i = 0; i < imageFileList!.length; i++) {
        UploadImageCheckin(imageFileList![i].path, imageFileList![i].name);
      }
    } catch (e) {
      print(e);
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
        title: Text('เช็คอินสถานที่'),
        backgroundColor: HexColor('#9C9AFC'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, "FALSE");
            },
            icon: Icon(Icons.close)),
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
                ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(img, scale: 1.0),
                    ),
                    title: Text('${name}')),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: text,
                    maxLines: 4,
                    // controller: text,
                    decoration: InputDecoration(
                      hintText: "ข้อความ",
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
                              itemCount: imageFileList!.length,
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
                                          height: 100,
                                          image: FileImage(
                                              File(imageFileList![index].path)),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: InkWell(
                                            onTap: () {
                                              imageFileList!.removeAt(index);
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
                        String images = imageFileList!
                            .map<String>((xfile) => xfile.name)
                            .toList()
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", "");
                        print(images);
                        if (text.text.isNotEmpty) {
                          String value = '';
                          if (images == "") {
                            value = await add_Checkin(
                                "add", id, widget.pid, text, '');
                          } else {
                            await add_Checkin(
                                "add", id, widget.pid, text, images);
                          }
                          if (value != "FASLE") {
                            if (imageFileList!.isNotEmpty) {
                              uploadImage();
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('เช็คอินสถานที่สำเร็จ')));
                            print(value);
                          } else {
                            print("error");
                          }

                          Navigator.pop(context, "TRUE");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('กรุณากรอกข้อมูล')));
                        }
                      },
                      child: Text("เช็คอินสถานที่"),
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
