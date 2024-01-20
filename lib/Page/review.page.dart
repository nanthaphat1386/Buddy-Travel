import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectbdtravel/API/apiReview.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReview extends StatefulWidget {
  final String pid;
  const AddReview({Key? key, required this.pid}) : super(key: key);

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  String id = '';
  String name = '';
  String img = '';

  int point = 1;

  String text = '';

  List<XFile>? imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();

  @override
  initState() {
    getProfile();
    super.initState();
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
    if (imageFileList!.length > 5) {
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
        title: Text('รีวิวสถานที่ท่องเที่ยว'),
        backgroundColor: HexColor('#9C9AFC'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, "FASLE");
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
          width: w * 1,
          //height: h * 0.9,
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
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      width: w * 0.9,
                      alignment: Alignment.center,
                      child: RatingBar.builder(
                        initialRating: 1,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            point = rating.toInt();
                          });
                        },
                      ),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "ข้อความรีวิว",
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
                    onChanged: (value) {
                      setState(() {
                        text = value;
                      });
                    },
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
                        String value = await add_Review("add", widget.pid, id,
                            point.toString(), text, images);
                        if (value == "TRUE") {
                          for (int i = 0; i < imageFileList!.length; i++) {
                            UploadImageReview(
                                imageFileList![i].path, imageFileList![i].name);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('เพิ่มรีวิวสำเร็จ')));
                          Navigator.pop(context, "TRUE");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('เพิ่มรีวิวไม่สำเร็จ')));
                        }
                      },
                      child: Text("รีวิวสถานที่ท่องเที่ยว"),
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

class EditReview extends StatefulWidget {
  final String rid;
  const EditReview({Key? key, required this.rid}) : super(key: key);

  @override
  State<EditReview> createState() => _EditReviewState();
}

class _EditReviewState extends State<EditReview> {
  String id = '';
  String name = '';
  String img = '';

  double point = 0.0;
  TextEditingController text = new TextEditingController();

   List imageFileList = [];
  List<XFile>? imageFileListAdd = [];
  final ImagePicker imagePicker = ImagePicker();

  @override
  initState() {
    super.initState();
    getProfile();
    getReview(widget.rid);
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

  void getReview(String rid) async {
    print(rid);
    var data;
    try {
      data = await get_ReviewByRID(rid);
      setState(() {
        text.text = data["R_Text"];
        point = double.parse(data["R_Point"]);
         imageFileList = data['R_Image'];
      });
    } catch (e) {}
    print(data);
  }

  void selectImages() async {
    if (imageFileList.length + imageFileListAdd!.length >= 5) {
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
        title: Text('แก้ไขการรีวิว'),
        backgroundColor: HexColor('#9C9AFC'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, "FASLE");
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
          width: w * 1,
          //height: h * 0.9,
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
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      width: w * 0.9,
                      alignment: Alignment.center,
                      child: RatingBar.builder(
                        initialRating: point,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            point = rating;
                          });
                        },
                      ),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: text,
                    maxLines: 4,
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
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                                          height: 100,
                                          image: FileImage(
                                              File(imageFileListAdd![index].path)),
                                        ),
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
                        String value = await edit_Review(
                            "edit",
                            widget.rid,
                            text,
                            point.toInt().toString(),
                            images.isEmpty ? "" : images,
                            images_new.isEmpty ? "" : images_new);
                        if (value == "TRUE") {
                          for (int i = 0; i < imageFileListAdd!.length; i++) {
                            UploadImageReview(imageFileListAdd![i].path,
                                imageFileListAdd![i].name);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('แก้ไขสำเร็จ')));
                          Navigator.pop(context, "TRUE");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('แก้ไขไม่สำเร็จ')));
                        }
                      },
                      child: Text("ยืนยันการแก้ไข"),
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
