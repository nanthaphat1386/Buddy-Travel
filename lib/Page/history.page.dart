import 'package:flutter/material.dart';
import 'package:projectbdtravel/API/apiPlace.dart';

class History_Place extends StatefulWidget {
  final String id;
  const History_Place({Key? key, required this.id}) : super(key: key);

  @override
  State<History_Place> createState() => _History_PlaceState();
}

class _History_PlaceState extends State<History_Place> {
  List data = [];

  @override
  void initState() {
    // TODO: implement initState
    getData(widget.id);
    super.initState();
  }

  Future getData(String id) async {
    var history = await getHistoryPlace(id);
    setState(() {
      data = history;
    });

    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ประวัติการแก้ไขสถานที่"),
        backgroundColor: Color.fromARGB(122, 116, 63, 238),
      ),
      body: ListView(children: [
        for (int i = 0; i < data.length; i++)
          Card(
            child: ListTile(
              title: data[i]["type"] == "add"
                  ? Text('เพิ่มโดย ${data[i]["Name"]}')
                  : Text('แก้ไขโดย ${data[i]["Name"]}'),
              subtitle: data[i]["type"] == "add" 
                  ? Text('เพิ่มเมื่อ ${data[i]["date"]}')
                  : Text('แก้ไขเมื่อ ${data[i]["date"]}'),
            ),
          )
      ]),
    );
  }
}
