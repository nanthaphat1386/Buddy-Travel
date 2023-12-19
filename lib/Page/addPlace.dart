import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiPlace.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({super.key});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  List<String> auto_type = [];
  List<String> auto_fes = [];
  String str_type = '';
  String str_fes = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List_Type();
    List_Festival();
  }

  // ignore: non_constant_identifier_names
  Future List_Type() async {
    auto_type = await ListType();
    return auto_type;
  }

  Future List_Festival() async {
    auto_fes = await ListFestival();
    return auto_fes;
  }

  Future<void> _showNotiDialog(
      BuildContext context, String str, String noti, IconData icon) {
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
                    leading: Icon(
                      icon,
                      color: Color.fromARGB(167, 81, 69, 250),
                    ),
                    trailing: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'ตกลง',
                            style: TextStyle(
                                color: Color.fromARGB(167, 81, 69, 250)),
                          ),
                        )),
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
    double h = displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    Autocomplete textAuto(String header) {
      return Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          return header == 'type'
              ? auto_type.where((String option) {
                  return option.contains(textEditingValue.text);
                })
              : auto_fes.where((String option) {
                  return option.contains(textEditingValue.text);
                });
        },
        // displayStringForOption: (Continent option) => option.name,
        fieldViewBuilder: (BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: Color.fromARGB(122, 116, 63, 238)),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: Color.fromARGB(122, 116, 63, 238)),
                  borderRadius: BorderRadius.circular(15)),
              hintText: header == 'type' ? 'ประเภทสถานที่' : 'เทศกาล',
              suffixIcon: Icon(Icons.search),
            ),
            style: const TextStyle(
                fontWeight: FontWeight.normal, fontFamily: 'Urbanist'),
          );
        },
        onSelected: (String str) {
          print('Selected: ${str}');
          header == 'type' ? str_type = str : str_fes = str;
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                width: w * 0.9,
                child: ListView.builder(
                  padding: EdgeInsets.all(0.5),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);

                    return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black12)),
                          child: ListTile(
                            title: Text(option,
                                style: const TextStyle(color: Colors.black)),
                          ),
                        ));
                  },
                ),
              ),
            ),
          );
        },
      );
    }

    Container Type_Page() {
      return Container(
          width: w * 1,
          height: h * 1,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: textAuto('type'),
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(HexColor('#9C9AFC'))),
                  onPressed: () async {
                    String ans = await addType(str_type);
                    if (ans == 'TRUE') {
                      _showNotiDialog(context, 'สำเร็จ',
                          'เพิ่มประเภทสถานที่สำเร็จ', Icons.done);
                    } else if (ans == 'INCORRECT') {
                      _showNotiDialog(context, 'แจ้งเตือน',
                          'มีข้อมูลในระบบแล้ว', Icons.warning);
                    } else {
                      _showNotiDialog(context, 'แจ้งเตือน',
                          'เพิ่มประเภทสถานที่ไม่สำเร็จ', Icons.warning);
                    }
                  },
                  child: Text('เพิ่มประเภทสถานที่'))
            ],
          ));
    }

    Container Festival_Page() {
      return Container(
          width: w * 1,
          height: h * 1,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: textAuto('festival'),
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(HexColor('#9C9AFC'))),
                  onPressed: () async {
                    String ans = await addFestival(str_fes);
                    if (ans == 'TRUE') {
                      _showNotiDialog(context, 'สำเร็จ',
                          'เพิ่มข้อมูลเทศกาลสำเร็จ', Icons.done);
                    } else if (ans == 'INCORRECT') {
                      _showNotiDialog(context, 'แจ้งเตือน',
                          'มีข้อมูลในระบบแล้ว', Icons.warning);
                    } else {
                      _showNotiDialog(context, 'แจ้งเตือน',
                          'เพิ่มข้อมูลเทศกาลไม่สำเร็จ', Icons.warning);
                    }
                  },
                  child: Text('เพิ่มเทศกาล'))
            ],
          ));
    }

    Container Place_Page() {
      return Container(
          width: w * 1,
          height: h * 1,
          child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  child: TabBar(
                    labelColor: Colors.blueAccent,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(text: 'กรอกด้วยตัวเอง'),
                      Tab(text: 'ค้นหาด้วย Google'),
                    ],
                  ),
                ),
                Container(
                    width: w,
                    height: h * 1.95, //height of TabBarView
                    padding: EdgeInsets.only(top: 5),
                    child: TabBarView(children: <Widget>[
                      Container(
                          color: Colors.amberAccent,
                          child: ListView(
                            children: [
                              Center(
                                child: Text('1111111111111'),
                              ),
                            ],
                          )),
                       Container(
                          color: Colors.amberAccent,
                          child: ListView(
                            children: [
                              Center(
                                child: Text('2222222222222'),
                              ),
                            ],
                          )),
                    ]))
              ],
            ),
          ));
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('เพิ่มข้อมูล'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, 'true');
              },
              icon: Icon(Icons.arrow_back)),
          backgroundColor: Color.fromARGB(122, 116, 63, 238),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                text: 'สถานที่',
              ),
              Tab(
                icon: Icon(Icons.home_work),
                text: 'ประเภท',
              ),
              Tab(
                icon: Icon(Icons.festival),
                text: 'เทศกาล',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Place_Page(),
            Type_Page(),
            Festival_Page(),
          ],
        ),
      ),
    );
  }
}
