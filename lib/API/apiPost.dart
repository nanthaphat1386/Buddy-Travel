import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future get_ListCheckin(String id) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/getCheckinFriend.php');
    var response = await http.post(url, body: {'id': id});
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}

Future get_CheckinByID(String cid) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/getCheckinByID.php');
    var response = await http.post(url, body: {'cid': cid});
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}

Future add_Checkin(String type, String mid, String pid,
    TextEditingController text, String image) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/checkin.php');
    if (image == '') {
      var response = await http.post(url, body: {
        'type': type,
        'mid': mid,
        'pid': pid,
        'text': text.text,
      });
      data = jsonDecode(response.body);
    } else {
      var response = await http.post(url, body: {
        'type': type,
        'mid': mid,
        'pid': pid,
        'text': text.text,
        'image': image
      });
      data = jsonDecode(response.body);
    }
  } catch (e) {}
  print(data);
  return data;
}

Future delete_Checkin(String type, String cid) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/checkin.php');
    var response = await http.post(url, body: {
      'type': type,
      'cid': cid,
    });
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}

Future edit_Checkin(String type, String cid, TextEditingController text,String img, String new_img) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/checkin.php');
    var response = await http.post(url, body: {
      'type': type,
      'cid': cid,
      'text': text.text,
      'image': img,
      'image_new': new_img
    });
    data = jsonDecode(response.body);
  } catch (e) {}
  print(data);
  return data;
}

UploadImageCheckin(String fileImage, String imgName) async {
  var formData = dio.FormData.fromMap(
      {'file': await dio.MultipartFile.fromFile(fileImage, filename: imgName)});
  var response = await Dio()
      .post(
          'https://bdtravel.comsciproject.net/buddy_travel/api/UploadImageToCheckin.php',
          data: formData)
      .then((value) => print("Response ==> $value"));
}
