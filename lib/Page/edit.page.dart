import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:projectbdtravel/API/apiUser.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:projectbdtravel/Tools/style.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController editName = new TextEditingController();
  TextEditingController editSurname = new TextEditingController();
  TextEditingController dateinput = new TextEditingController();

  String image =
      'https://bdtravel.comsciproject.net/buddy_travel/Upload/Picture/Profile/';
  String imgProfile = '';
  String id = '';
  String name = '';
  String surname = '';
  String imageFile = '';
  String imageName = '';
  File? imgShow;

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
        imgProfile = prefs.getString('image').toString();
        id = prefs.getString('id').toString();
        name = prefs.getString('fName').toString();
        surname = prefs.getString('lName').toString();
        dateinput.text = prefs.getString('date').toString();
      });
    } catch (e) {
      print(e);
    }
  }

  void _openCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imgShow = File(pickedFile.path);
        imageFile = pickedFile.path;
        imageName = pickedFile.name;
      });
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imgShow = File(pickedFile.path);
        imageFile = pickedFile.path;
        imageName = pickedFile.name;
      });
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    Future<void> _showChoiceDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "โปรดเลือก",
                style: TextStyle(color: Colors.blue),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    const Divider(
                      height: 1,
                      color: Colors.blue,
                    ),
                    ListTile(
                      onTap: () {
                        _openGallery(context);
                      },
                      title: const Text("แกลเลอรี่"),
                      leading: const Icon(
                        Icons.account_box,
                        color: Colors.blue,
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.blue,
                    ),
                    ListTile(
                      onTap: () {
                        _openCamera(context);
                      },
                      title: const Text("กล้องถ่ายรูป"),
                      leading: const Icon(
                        Icons.camera,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

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

    Padding myTextFieldDate() {
      return Padding(
        padding: EdgeInsets.fromLTRB(w * 0.05, h * 0.01, w * 0.05, h * 0.01),
        child: TextField(
          controller: dateinput,
          //editing controller of this TextField
          decoration: InputDecoration(
            labelText: "วัน/เดือน/ปีเกิด",
            labelStyle: TextStyle(color: Color.fromARGB(255, 81, 69, 250)),
            prefixIcon: const Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(Icons.calendar_month,
                    color: Color.fromARGB(167, 81, 69, 250))),
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
          ),

          readOnly: true,
          //set it true, so that user will not able to edit text
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2150));

            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('dd-MM-yyyy').format(pickedDate);
              setState(() {
                dateinput.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {}
          },
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
                      Navigator.pop(context, 'false');
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(w * 0.03),
                      child: Text(
                        'แก้ไขโปรไฟล์',
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
                          SizedBox(
                            width: w * 0.35,
                            height: w * 0.35,
                            child: (imgShow == null)
                                ? CircleAvatar(
                                    radius: w * 0.25,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: w * 0.25,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          NetworkImage(imgProfile, scale: 1.0),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: w * 0.065,
                                          child: IconButton(
                                            onPressed: () {
                                              _showChoiceDialog(context);
                                            },
                                            icon: const Icon(
                                              Icons.camera_alt,
                                              size: 30,
                                            ),
                                            color: Color.fromARGB(
                                                167, 81, 69, 250),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: w * 0.25,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: w * 0.25,
                                      backgroundImage: FileImage(imgShow!),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: w * 0.065,
                                          child: IconButton(
                                            onPressed: () {
                                              _showChoiceDialog(context);
                                            },
                                            icon: const Icon(
                                              Icons.camera_alt,
                                              size: 30,
                                            ),
                                            color: Color.fromARGB(
                                                255, 81, 69, 250),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          myTextField('ชื่อ', name, Icons.person, editName),
                          myTextField(
                              'นามสกุล', surname, Icons.person, editSurname),
                          myTextFieldDate(),
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
                                String anwser = await UpdateProfile(
                                    id,
                                    editName.text.isEmpty
                                        ? name
                                        : editName.text,
                                    editSurname.text.isEmpty
                                        ? surname
                                        : editSurname.text,
                                    dateinput,
                                    imgShow == null
                                        ? imgProfile
                                        : image + imageName);
                                if (anwser == 'TRUE') {
                                  if (imgShow != null) {
                                    UploadImage(imageFile, imageName);
                                  }
                                }
                                await Future.delayed(
                                            const Duration(milliseconds: 1000));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'แก้ไขข้อมูลสำเร็จ')));
                                Navigator.pop(context, 'true');
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

////////////////////////////////////////////////////////////////////////////

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  TextEditingController text_old_password = new TextEditingController();
  TextEditingController text_new_password = new TextEditingController();
  TextEditingController text_password = new TextEditingController();
  String password = '';
  String id = '';

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
        id = prefs.getString('id').toString();
        password = prefs.getString('password').toString();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    Padding myTextField(
        String header, IconData icon, TextEditingController text) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, h * 0.01, 0, h * 0.01),
        child: SizedBox(
          width: w * 0.7,
          height: h * 0.07,
          child: TextField(
            controller: text,
            obscureText: true,
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
              labelStyle: TextStyle(color: Color.fromARGB(255, 81, 69, 250)),
            ),
          ),
        ),
      );
    }

    Future<void> _showNotiDialog(
        BuildContext context, String str, String noti, Icon icon) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                str,
                style: TextStyle(
                  color: Color.fromARGB(167, 81, 69, 250),
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    const Divider(
                      height: 1,
                      color: Color.fromARGB(167, 81, 69, 250),
                    ),
                    ListTile(
                      title: Text(noti),
                      leading: icon,
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                              color: Color.fromARGB(167, 81, 69, 250)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
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
                        'เปลี่ยนรหัสผ่าน',
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
                              'รหัสผ่านเดิม', Icons.key, text_old_password),
                          myTextField(
                              'รหัสผ่านใหม่', Icons.key, text_new_password),
                          myTextField(
                              'รหัสผ่านใหม่อีกครั้ง', Icons.key, text_password),
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
                                if (text_old_password.text.isNotEmpty &&
                                    text_new_password.text.isNotEmpty &&
                                    text_password.text.isNotEmpty) {
                                  if (password
                                      .contains(text_old_password.text)) {
                                    if (text_new_password.text
                                        .contains(text_password.text)) {
                                      String value = await UpdatePassword(
                                          id, text_new_password);
                                      if (value.contains('TRUE')) {
                                        await Future.delayed(
                                            const Duration(milliseconds: 1000));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'เปลี่ยนรหัสผ่านสำเร็จ')));
                                        Navigator.pop(context, 'TRUE');
                                      }
                                    } else {
                                      _showNotiDialog(
                                          context,
                                          'แจ้งเตือน',
                                          'รหัสผ่านไม่ถูกต้อง',
                                          Icon(Icons.warning));
                                    }
                                  } else {
                                    _showNotiDialog(
                                        context,
                                        'แจ้งเตือน',
                                        'รหัสผ่านไม่ถูกต้อง',
                                        Icon(Icons.warning));
                                  }
                                } else {
                                  _showNotiDialog(context, 'แจ้งเตือน',
                                      'กรุณากรอกข้อมูล', Icon(Icons.warning));
                                }
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
