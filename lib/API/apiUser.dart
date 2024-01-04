import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

saveValue(var data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('id', data[0]['M_ID']);
  prefs.setString('fName', data[0]['M_fName']);
  prefs.setString('lName', data[0]['M_lName']);
  prefs.setString('password', data[0]['M_Password']);
  prefs.setString('email', data[0]['M_Email']);
  prefs.setString('image', data[0]['M_Image']);
  prefs.setString('date', data[0]['M_bDate']);
}

// ignore: non_constant_identifier_names
UploadImage(String fileImage, String imgName) async {
  var formData = dio.FormData.fromMap(
      {'file': await dio.MultipartFile.fromFile(fileImage, filename: imgName)});
  var response = await Dio()
      .post(
          'https://bdtravel.comsciproject.net/buddy_travel/api/uploadImageProfile.php',
          data: formData)
      .then((value) => print("Response ==> $value"));
}

Future login(String email, String password) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/login.php');
    var response =
        await http.post(url, body: {'email': email, 'password': password});
    data = jsonDecode(response.body);
    if (data.toString().isNotEmpty && data.toString().contains("INCORRECT")) {
    } else if (data.toString().isNotEmpty &&
        data.toString().contains("FALSE")) {
    } else {
      saveValue(data);
    }
  } catch (e) {
    print(e);
  }

  return data;
}

Future getDetailMember(String id) async {
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/getDetailMember.php');
  var response = await http.post(url, body: {'id': id});
  var data = jsonDecode(response.body);
  return data;
}

Future Profile_info(String id) async {
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/checkin.profile.php');
  var response = await http.post(url, body: {'id': id});
  var data = jsonDecode(response.body);
  return data;
}

Future<String> register(
  TextEditingController email,
  TextEditingController name,
  TextEditingController surname,
  TextEditingController password,
  TextEditingController dateinput,
  File image,
  String imageName,
) async {
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/register.php');
  var response;
  if (image.path.isEmpty) {
    response = await http.post(url, body: {
      'fname': name.text.toString(),
      'lname': surname.text.toString(),
      'email': email.text.toString(),
      'password': password.text.toString(),
      'bdate': dateinput.text.toString(),
      'image': ''
    });
  } else {
    response = await http.post(url, body: {
      'fname': name.text.toString(),
      'lname': surname.text.toString(),
      'email': email.text.toString(),
      'password': password.text.toString(),
      'bdate': dateinput.text.toString(),
      'image':
          'https://bdtravel.comsciproject.net/buddy_travel/Upload/Picture/$imageName'
    });
  }
  var data = jsonDecode(response.body);
  return data.toString();
}

Future<String> UpdateProfile(String id, String name, String surname,
    TextEditingController bdate, String image) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/editprofile.php');
  var response = await http.post(url, body: {
    'id': id,
    'name': name,
    'surname': surname,
    'date': bdate.text,
    'image': image
  });
  var data = jsonDecode(response.body);
  if (data.toString().contains('TRUE')) {
    prefs.setString('fName', name);
    prefs.setString('lName', surname);
    prefs.setString('date', bdate.text);
    prefs.setString('image', image);
  }
  return data.toString();
}

Future<String> UpdatePassword(String id, TextEditingController password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/editpassword.php');
  var response =
      await http.post(url, body: {'id': id, 'password': password.text});
  var data = jsonDecode(response.body);
  if (data.toString().contains('TRUE')) {
    prefs.setString('password', password.text);
  }
  return data.toString();
}

bool checkEmail(String email) {
  final bool isValid = EmailValidator.validate(email);
  return isValid;
}
