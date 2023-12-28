import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiUser.dart';
import 'package:projectbdtravel/Page/login.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:projectbdtravel/Tools/style.tools.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = new TextEditingController();
  TextEditingController surname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController password_check = new TextEditingController();
  TextEditingController dateinput = new TextEditingController();
  String imageFile = '';
  String imageName = '';
  File? imgShow;

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
                        style:
                            TextStyle(color: Color.fromARGB(167, 81, 69, 250)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    Padding myTextField(String str, Icon icon, TextEditingController text) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, h * 0.01, 0, h * 0.01),
        child: SizedBox(
          width: w * 0.7,
          height: h * 0.07,
          child: TextField(
            controller: text,
            decoration: InputDecoration(
              prefixIcon:
                  Align(widthFactor: 1.0, heightFactor: 1.0, child: icon),
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
              labelText: str,
              labelStyle: TextStyle(color: Color.fromARGB(255, 81, 69, 250)),
            ),
          ),
        ),
      );
    }

    Padding myTextFieldPs(String str, Icon icon, TextEditingController text) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, h * 0.01, 0, h * 0.01),
        child: SizedBox(
          width: w * 0.7,
          height: h * 0.07,
          child: TextField(
            controller: text,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon:
                  Align(widthFactor: 1.0, heightFactor: 1.0, child: icon),
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
              labelText: str,
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
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(0, h * 0.055, 0, 0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: w * 0.1,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
              width: w * 0.85,
              height: h * 0.925,
              margin:
                  EdgeInsets.fromLTRB(w * 0.1, h * 0.025, w * 0.1, h * 0.045),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(w * 0.03),
                      child: Text(
                        'สมัครสมาชิก',
                        style: styleText.registerText,
                      ),
                    ),
                    SizedBox(
                      width: w * 0.35,
                      height: w * 0.35,
                      child: (imgShow == null)
                          ? CircleAvatar(
                              radius: w * 0.25,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: w * 0.25,
                                backgroundImage: const AssetImage(
                                    'assets/img/accountIcon.jpg'),
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
                                      color: Color.fromARGB(167, 81, 69, 250),
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
                                      color: Color.fromARGB(255, 81, 69, 250),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    myTextField(
                        'ชื่อ',
                        const Icon(Icons.person,
                            color: Color.fromARGB(167, 81, 69, 250)),
                        name),
                    myTextField(
                        'นามสกุล',
                        const Icon(Icons.person,
                            color: Color.fromARGB(167, 81, 69, 250)),
                        surname),
                    myTextField(
                        'อีเมล',
                        const Icon(Icons.email,
                            color: Color.fromARGB(167, 81, 69, 250)),
                        email),
                    myTextFieldPs(
                        'รหัสผ่าน',
                        const Icon(Icons.lock,
                            color: Color.fromARGB(167, 81, 69, 250)),
                        password),
                    myTextFieldPs(
                        'รหัสผ่านอีกครั้ง',
                        const Icon(Icons.lock,
                            color: Color.fromARGB(167, 81, 69, 250)),
                        password_check),
                    myTextFieldDate(),
                    ButtonTheme(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color.fromARGB(167, 81, 69, 250)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                        ),
                        onPressed: () async {
                          bool check_email = checkEmail(email.text);
                          print(check_email);
                          if (check_email) {
                            if (password.text.contains(password_check.text)) {
                              var answer = await register(email, name, surname,
                                  password, dateinput, imgShow!, imageName);
                              if (answer.contains("EMAIL ALREADY USED")) {
                                //       print('tt');
                              } else if (answer.contains("TRUE")) {
                               _showNotiDialog(
                                context,
                                'สำเร็จ',
                                'สมัครสมาชิกสำเร็จ',
                                Icon(Icons.done_outline,
                                    color: Color.fromARGB(167, 81, 69, 250)));
                                Timer(Duration(seconds: 3), () {
                                  Navigator.pop(context);
                                });
                                if (imgShow != null) {
                                  UploadImage(imageFile, imageName);
                                }
                              } else {
                                _showNotiDialog(
                                context,
                                'แจ้งเตือน',
                                'สมัครสมาชิกไม่สำเร็จ',
                                Icon(Icons.warning,
                                    color: Color.fromARGB(167, 81, 69, 250)));
                              }
                            } else {
                              _showNotiDialog(
                                context,
                                'แจ้งเตือน',
                                'รหัสผ่านไม่ถูกต้อง',
                                Icon(Icons.warning,
                                    color: Color.fromARGB(167, 81, 69, 250)));
                            }
                          } else {
                            _showNotiDialog(
                                context,
                                'แจ้งเตือน',
                                'กรอกอีเมลไม่ถูก',
                                Icon(Icons.question_mark,
                                    color: Color.fromARGB(167, 81, 69, 250)));
                          }
                        },
                        child: const Text(
                          "ยืนยันการสมัครสมาชิก",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}
