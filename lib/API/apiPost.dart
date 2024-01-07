import 'dart:convert';
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