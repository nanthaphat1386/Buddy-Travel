import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiPlace.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:projectbdtravel/Tools/style.tools.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({super.key});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  List<String> auto_type = [];
  List<String> auto_fes = [];
  List<String> allProvince = [];
  String str_type = '';
  String str_fes = '';

  Color purpleBorder = HexColor('#9C9AFC');
  Color blackBorder = Colors.black26;

  String dropdownValue = '';

  TextEditingController name_Place = new TextEditingController();
  TextEditingController description_Place = new TextEditingController();
  TextEditingController address_Place = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List_Type();
    List_Festival();
    List_Province();
  }

  // ignore: non_constant_identifier_names
  Future List_Type() async {
    var data = await ListType();
    setState(() {
      auto_type = data;
    });

    return auto_type;
  }

  Future List_Festival() async {
    var data = await ListFestival();
    setState(() {
      auto_fes = data;
    });
    return auto_fes;
  }

  Future List_Province() async {
    var data = await getProvince();
    setState(() {
      allProvince = data;
    });

    return allProvince;
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
                  borderSide: BorderSide(width: 1, color: purpleBorder),
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: purpleBorder),
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

    Padding myTextField(String str, TextEditingController text) {
      return Padding(
          padding: EdgeInsets.fromLTRB(0, h * 0.01, 0, h * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(str, style: styleText.styleHeaderPlace),
              SizedBox(
                width: w * 1,
                height: h * 0.2,
                child: TextField(
                  controller: text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: purpleBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: purpleBorder),
                    ),
                  ),
                ),
              ),
            ],
          ));
    }

    Container dropdownMenu(List<String> header, String head) {
      return Container(
          width: w * 0.4,
          height: h * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(head, style: styleText.styleHeaderPlace),
              DropdownMenu<String>(
                width: w * 0.4,
                menuHeight: h * 0.5,
                initialSelection: '',
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                inputDecorationTheme: InputDecorationTheme(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: purpleBorder)),
                ),
                dropdownMenuEntries:
                    header.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(
                    value: value,
                    label: value,
                  );
                }).toList(),
              ),
            ],
          ));
    }

    Padding myTextFieldWidthMax(
        String str, TextEditingController text, double size_h, int maxLine) {
      return Padding(
          padding: EdgeInsets.fromLTRB(0, h * 0.02, 0, h * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                str,
                style: styleText.styleHeaderPlace,
              ),
              SizedBox(
                width: w * 1,
                height: h * size_h,
                child: TextField(
                  maxLines: maxLine,
                  controller: text,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: purpleBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: purpleBorder),
                    ),
                  ),
                ),
              ),
            ],
          ));
    }

    Padding myTextFieldWidthMid(
        String str, TextEditingController text, bool status) {
      return Padding(
          padding: EdgeInsets.fromLTRB(0, h * 0.01, 0, h * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                str,
                style: styleText.styleHeaderPlace,
              ),
              SizedBox(
                width: w * 0.4,
                height: h * 0.195,
                child: TextField(
                  maxLines: 1,
                  controller: text,
                  enabled: status,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: purpleBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: purpleBorder),
                    ),
                  ),
                ),
              ),
            ],
          ));
    }

    Container emptyBoxShow() {
      return Container(
        width: w * 0.4,
        height: h * 0.4,
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: purpleBorder)),
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            for (int i = 0; i < 15; i++) Text('sss'),
          ],
        ),
      );
    }

    Container Place_Page() {
      return Container(
        color: Color.fromARGB(150, 214, 214, 214),
          width: w * 1,
          height: h * 1,
          child: SingleChildScrollView(
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
                            padding: EdgeInsets.all(10),
                            child: ListView(
                              children: [
                                myTextField('ชื่อสถานที่', name_Place),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      dropdownMenu(auto_type, 'ประเภทสถานที่'),
                                      dropdownMenu(auto_fes, 'เทศกาล'),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      emptyBoxShow(),
                                      emptyBoxShow(),
                                    ],
                                  ),
                                ),
                                myTextFieldWidthMax(
                                    'ข้อความอธิบาย', description_Place, 0.4, 5),
                                myTextFieldWidthMax(
                                    'ที่อยู่', address_Place, 0.2, 2),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    dropdownMenu(allProvince, 'จังหวัด'),
                                    myTextFieldWidthMid(
                                        'รหัสไปรษณีย์', address_Place, true),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    HexColor('#9C9AFC'))),
                                        onPressed: () {},
                                        child: Text(
                                          'เพิ่มรูปภาพ',
                                          style:
                                              TextStyle(fontFamily: 'Urbanist'),
                                        )),
                                    Container(
                                      width: w * 0.6,
                                      height: h * 0.5,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: purpleBorder)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: w * 0.5,
                                        height: h * 0.145,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      purpleBorder)),
                                          child: Text('เลือกสถานที่'),
                                          onPressed: () {},
                                        ))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    myTextFieldWidthMid(
                                        'ละติจูด', address_Place,false),
                                    myTextFieldWidthMid(
                                        'ลองติจูด', address_Place,false),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: w * 0.5,
                                        height: h * 0.145,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      purpleBorder)),
                                          child: Text('เพิ่มสถานที่ท่องเที่ยว'),
                                          onPressed: () {},
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.all(10),
                            child: ListView(
                              children: [
                                myTextField('ชื่อสถานที่', name_Place),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      dropdownMenu(auto_type, 'ประเภทสถานที่'),
                                      dropdownMenu(auto_fes, 'เทศกาล'),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      emptyBoxShow(),
                                      emptyBoxShow(),
                                    ],
                                  ),
                                ),
                                myTextFieldWidthMax(
                                    'ข้อความอธิบาย', description_Place, 0.4, 5),
                                myTextFieldWidthMax(
                                    'ที่อยู่', address_Place, 0.2, 2),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    dropdownMenu(allProvince, 'จังหวัด'),
                                    myTextFieldWidthMid(
                                        'รหัสไปรษณีย์', address_Place,false),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    HexColor('#9C9AFC'))),
                                        onPressed: () {},
                                        child: Text(
                                          'เพิ่มรูปภาพ',
                                          style:
                                              TextStyle(fontFamily: 'Urbanist'),
                                        )),
                                    Container(
                                      width: w * 0.6,
                                      height: h * 0.5,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: purpleBorder)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    myTextFieldWidthMid(
                                        'ละติจูด', address_Place,false),
                                    myTextFieldWidthMid(
                                        'ลองติจูด', address_Place, false),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: w * 0.5,
                                        height: h * 0.145,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      purpleBorder)),
                                          child: Text('เพิ่มสถานที่ท่องเที่ยว'),
                                          onPressed: () {},
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                      ]))
                ],
              ),
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
