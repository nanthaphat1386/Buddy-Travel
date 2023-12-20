// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
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

Future<String> addType(String festival) async {
  Uri url = Uri.parse(
      'https://bdtravel.comsciproject.net/buddy_travel/api/addtype.php');
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

Future<List<String>> getProvince() async {
  Uri url = Uri.parse(
      'https://raw.githubusercontent.com/kongvut/thai-province-data/master/api_province.json');
  var response = await http.get(url);
  // ignore: prefer_typing_uninitialized_variables
  var data;
  List<String> list=[];
  try {
    data = jsonDecode(response.body);
    for (int i=0;i<data.length;i++){
      list.add(data[i]['name_th']);
    }
  } catch (e) {
    print(e);
  }
  print(list);
  return list;
}
