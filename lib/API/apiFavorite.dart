import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future get_ListFavorite(String id) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/getFavorite.php');
    var response = await http.post(url, body: {'id': id});
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}

Future edit_name_ListFavorite(String id, String name) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/editFavorite.php');
    var response = await http.post(url, body: {'id': id, 'name': name});
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}

Future remove_ListFavorite(String type, String id) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/removeFavorite.php');
    var response = await http.post(url, body: {'type': type, 'id': id});
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}

Future add_ListFavorite(
    String type, String id, TextEditingController name) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/addFavorite.php');
    var response =
        await http.post(url, body: {'type': type, 'id': id, 'name': name.text});
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}

Future add_PlaceFavorite(String type, String id, String pid) async {
  var data;
  
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/addFavorite.php');
    var response =
        await http.post(url, body: {'type': type, 'id': id, 'pid': pid});
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}

Future dropdown_Favorite(String id) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/ddFavorite.php');
    var response = await http.post(url, body: {'id': id});
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}

Future remove_fav_place(String type, String fa_id, String id) async {
  var data;
  try {
    Uri url = Uri.parse(
        'https://bdtravel.comsciproject.net/buddy_travel/api/removeFavorite.php');
    var response =
        await http.post(url, body: {'type': type, 'fa_id': fa_id, 'id': id});
    data = jsonDecode(response.body);
  } catch (e) {}
  return data;
}
