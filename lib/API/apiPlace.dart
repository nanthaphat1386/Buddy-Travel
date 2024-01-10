// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

Future<List> getPlace() async {
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/place.php');
  var response = await http.get(url);
  // ignore: prefer_typing_uninitialized_variables
  var data;
  try {
    data = jsonDecode(response.body);
  } catch (e) {}

  if (data.toString().isEmpty) {
    data = 'ไม่มีข้อมูล';
  }
  return data;
}

Future<String> addPlace(
    String id,
    TextEditingController name,
    TextEditingController description,
    String address,
    TextEditingController lat,
    TextEditingController lng,
    String date) async {
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/addPlace.php');
  var response = await http.post(url, body: {
    'id': id,
    'name': name.text,
    'description': description.text,
    'address': address,
    'lat': lat.text,
    'lng': lng.text,
    'date': date
  });
  // ignore: prefer_typing_uninitialized_variables
  var data;
  try {
    data = jsonDecode(response.body);
    print(data);
  } catch (e) {
    print(e);
  }
  return data;
}

Future<String> addTypeforPlace(String pid, String tid) async {
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/addType.list.php');
  var response = await http.post(url, body: {
    'pid': pid,
    'tid': tid,
  });
  // ignore: prefer_typing_uninitialized_variables
  var data;
  try {
    data = jsonDecode(response.body);
    print(data);
  } catch (e) {
    print(e);
  }
  return data;
}

Future<String> addFestivalforPlace(String pid, String fid) async {
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/addFestival.list.php');
  var response = await http.post(url, body: {
    'pid': pid,
    'fid': fid,
  });
  // ignore: prefer_typing_uninitialized_variables
  var data;
  try {
    data = jsonDecode(response.body);
    print(data);
  } catch (e) {
    print(e);
  }
  return data;
}

Future<String> addImageforPlace(String pid, String name) async {
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/addPhoto_list.php');
  var response = await http.post(url, body: {
    'pid': pid,
    'image':
        'https://bdtravel.comsciproject.net/buddy_travel/Upload/Picture/Place/$name',
  });
  // ignore: prefer_typing_uninitialized_variables
  var data;
  try {
    data = jsonDecode(response.body);
    print(data);
  } catch (e) {
    print(e);
  }
  return data;
}

Future getPlaceID(String id) async {
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/detailPlace.php');
  var response = await http.post(url, body: {'P_ID': id});
  // ignore: prefer_typing_uninitialized_variables
  var data;
  try {
    data = jsonDecode(response.body);
  } catch (e) {
    print(e);
  }

  if (data.toString().isEmpty) {
    data = 'ไม่มีข้อมูล';
  }
  return data;
}

Future<List<String>> ListType() async {
  List<String> answer = [];
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/auto_type.php');
    var response = await http.get(url);
    data = json.decode(response.body);
    for (int i = 0; i < data.length; i++) {
      answer.add(data[i].toString());
    }
  } catch (e) {
    print(e);
  }
  return answer;
}

Future<List<String>> ListFestival() async {
  List<String> answer = [];
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/auto_festival.php');
    var response = await http.get(url);
    data = json.decode(response.body);
    for (int i = 0; i < data.length; i++) {
      answer.add(data[i].toString());
    }
  } catch (e) {
    print(e);
  }
  return answer;
}

Future<String> addFestival(String festival) async {
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/addfestival.php');
  var response = await http.post(url, body: {'name': festival});
  // ignore: prefer_typing_uninitialized_variables
  var data;
  try {
    data = jsonDecode(response.body);
  } catch (e) {
    print(e);
  }
  return data;
}

Future<String> addType(String type) async {
  print(type);
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/addtype.php');
  var response = await http.post(url, body: {'name': type});
  // ignore: prefer_typing_uninitialized_variables
  var data;
  try {
    data = jsonDecode(response.body);
  } catch (e) {
    print(e);
  }
  return data;
}

Future<List<String>> getProvince() async {
  Uri url = Uri.parse(
      'https://raw.githubusercontent.com/kongvut/thai-province-data/master/api_province.json');
  var response = await http.get(url);
  // ignore: prefer_typing_uninitialized_variables
  var data;
  List<String> list = [];
  try {
    data = jsonDecode(response.body);
    for (int i = 0; i < data.length; i++) {
      list.add(data[i]['name_th']);
    }
  } catch (e) {
    print(e);
  }
  print(list);
  return list;
}

Future getFestival() async {
  var data;
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/getFestival.php');
  var response = await http.get(url);
  // ignore: prefer_typing_uninitialized_variables
  try {
    data = jsonDecode(response.body);
  } catch (e) {
    print(e);
  }
  return data;
}

Future getType() async {
  var data;
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/getType.php');
  var response = await http.get(url);
  // ignore: prefer_typing_uninitialized_variables
  try {
    data = jsonDecode(response.body);
  } catch (e) {
    print(e);
  }
  return data;
}

Future deleteType(String id, String name) async {
  var data;
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/removeType.php');
  var response = await http.post(url, body: {'ID': id, 'name': name});
  // ignore: prefer_typing_uninitialized_variables
  try {
    data = jsonDecode(response.body);
  } catch (e) {
    print(e);
  }
  return data;
}

Future deleteFestival(String id, String name) async {
  var data;
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/removeFestival.php');
  var response = await http.post(url, body: {'ID': id, 'name': name});
  // ignore: prefer_typing_uninitialized_variables
  try {
    data = jsonDecode(response.body);
  } catch (e) {
    print(e);
  }
  return data;
}

Future closePlace(String id) async {
  var data;
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/closePlace.php');
  var response = await http.post(url, body: {
    'id': id,
  });
  // ignore: prefer_typing_uninitialized_variables
  try {
    data = jsonDecode(response.body);
  } catch (e) {
    print(e);
  }
  print(data);
  return data;
}

UploadImagePlace(String fileImage, String imgName) async {
  var formData = dio.FormData.fromMap(
      {'file': await dio.MultipartFile.fromFile(fileImage, filename: imgName)});
  var response = await Dio()
      .post(
          'https://bdtravel.comsciproject.net/buddy_travel/api/UploadImageToPlace.php',
          data: formData)
      .then((value) => print("Response ==> $value"));
}

Future edit_type_festival(String type, String id, String name) async {
  var data;
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/editTypeFes.php');
  var response =
      await http.post(url, body: {'type': type, 'id': id, 'name': name});
  // ignore: prefer_typing_uninitialized_variables
  try {
    data = jsonDecode(response.body);
  } catch (e) {
    print(e);
  }
  return data;
}
