import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiPlace.dart';
import 'package:projectbdtravel/Page/addPlace.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:projectbdtravel/Tools/style.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPlace extends StatefulWidget {
  final String id;
  const EditPlace({Key? key, required this.id}) : super(key: key);

  @override
  State<EditPlace> createState() => _EditPlaceState();
}

class _EditPlaceState extends State<EditPlace> {
  TextEditingController name_place = new TextEditingController();
  TextEditingController description_Place = new TextEditingController();
  TextEditingController address_Place = new TextEditingController();
  TextEditingController lat_place = new TextEditingController();
  TextEditingController lng_place = new TextEditingController();
  TextEditingController noProvince = new TextEditingController();

  String dropdownValue = '';
  List selects_type = [];
  List selects_fes = [];
  List<String> allProvince = [];
  String provinceValue = '';

  List<String> auto_type = [];
  List<String> auto_fes = [];
  List<String> type_id = [];
  List<String> type_Name = [];
  List type = [];
  List<String> type_add = [];
  List<String> festival_id = [];
  List<String> festival_Name = [];
  List festival = [];
  List<String> festival_add = [];

  String mid = '';

  Color purpleBorder = HexColor('#9C9AFC');
  Color blackBorder = Colors.black26;

  String checkList(List list, String str) {
    int ans = 0;
    for (int i = 0; i < list.length; i++) {
      if (str == list[i]) {
        ans++;
      }
    }
    return ans.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    detail();
    getProfile();
    List_Province();
    getTypePlace();
    getFestivalPlace();
    super.initState();
  }

  getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        mid = prefs.getString('id').toString();
      });
    } catch (e) {
      print(e);
    }
  }

  Future getTypePlace() async {
    type_Name.clear();
    try {
      var data = await getType();
      type = data;
      for (int i = 0; i < data.length; i++) {
        setState(() {
          type_Name.add(data[i]['T_Name'].toString());
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future getFestivalPlace() async {
    festival_Name.clear();
    try {
      var data = await getFestival();
      for (int i = 0; i < data.length; i++) {
        setState(() {
          festival_Name.add(data[i]['F_Name'].toString());
        });
      }

      festival = data;
    } catch (e) {
      print(e);
    }
  }

  Future List_Province() async {
    try {
      var data = await getProvince();
      setState(() {
        allProvince = data;
      });
    } catch (e) {
      print(e);
    }

    return allProvince;
  }

  void detail() async {
    var data = await getPlaceID(widget.id);
    for (int i = 0; i < data[0]["P_Type"].length; i++) {
      setState(() {
        selects_type.add(data[0]["P_Type"][i]);
      });
    }
    for (int i = 0; i < data[0]["P_Festival"].length; i++) {
      setState(() {
        selects_fes.add(data[0]["P_Festival"][i]);
      });
    }
    List<String> post = data[0]["P_Address"].toString().split(" ");
    String str_add = "";
    for (int i = 0; i < post.length - 2; i++) {
      str_add = str_add + " " + post[i];
    }
    setState(() {
      name_place.text = data[0]["P_Name"];
      description_Place.text = data[0]["P_Description"];
      lat_place.text = data[0]["P_Lat"];
      lng_place.text = data[0]["P_Lng"];
      address_Place.text = str_add;
      noProvince.text = post[post.length - 1];
      provinceValue = post[post.length - 2];
    });
    print(str_add);
  }

  Future<void> _showMyDialogEdit() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('คุณต้องการอัพเดตสถานที่ท่องเที่ยวใช่หรือไม่'),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 127, 97, 248))),
                      onPressed: () async {
                        List id_type = [];
                        List id_festival = [];
                        for (int a = 0; a < selects_fes.length; a++) {
                          for (int b = 0; b < festival.length; b++) {
                            if (selects_fes[a] == festival[b]["F_Name"]) {
                              id_festival.add(festival[b]["F_ID"]);
                            }
                          }
                        }
                        for (int a = 0; a < selects_type.length; a++) {
                          for (int b = 0; b < type.length; b++) {
                            if (selects_type[a] == type[b]["T_Name"]) {
                              id_type.add(type[b]["T_ID"]);
                            }
                          }
                        }
                        String add_type = id_type.toString().replaceAll("[", "").replaceAll("]", "");
                        String add_festival = id_festival.toString().replaceAll("[", "").replaceAll("]", "");
                        String value = await editPlace(
                            mid,
                            widget.id,
                            name_place,
                            description_Place,
                            '${address_Place.text} ${provinceValue} ${noProvince.text}',
                            add_type,
                            add_festival,
                            lat_place,
                            lng_place);
                        if (value == "TRUE") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('แก้ไขสถานที่สำเร็จ')));
                          Navigator.pop(context);
                          Navigator.pop(context, "TRUE");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('แก้ไขสถานที่ไม่สำเร็จ')));
                          Navigator.pop(context);
                        }
                        //Navigator.pop(context);
                      },
                      child: Text('ตกลง')),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text('ยกเลิก')),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogError() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ไม่สามารถแก้ไขได้'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('กรุณาตรวจสอบข้อมูลแล้วทำรายการใหม่อีกครั้ง'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'ตกลง',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    Container dropdownMenu(List<String> header, String head, String str) {
      return Container(
          width: w * 0.4,
          height: h * 0.125,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(head, style: styleText.styleHeaderPlace),
              DropdownMenu<String>(
                width: w * 0.4,
                menuHeight: h * 0.5,
                initialSelection: provinceValue,
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                    str == 'type'
                        ? checkList(selects_type, dropdownValue) == '0'
                            ? selects_type.add(dropdownValue)
                            : null
                        : str == 'festival'
                            ? checkList(selects_fes, dropdownValue) == '0'
                                ? selects_fes.add(dropdownValue)
                                : null
                            : provinceValue = dropdownValue;
                  });
                },
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: Colors.white,
                  filled: true,
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

    Container emptyBoxShow(List enter) {
      return Container(
        width: w * 0.4,
        height: h * 0.225,
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: purpleBorder)),
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            for (int i = 0; i < enter.length; i++)
              Stack(
                children: [
                  Text(enter[i]),
                  Positioned(
                      right: 1,
                      child: InkWell(
                        onTap: () {
                          enter.removeAt(i);
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.redAccent,
                          size: 12,
                        ),
                      ))
                ],
              ),
          ],
        ),
      );
    }

    Padding myTextFieldWidthMax(
        String str, TextEditingController text, double size_h, int maxLine) {
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
                height: h * 0.085,
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

    Container Place_Page() {
      return Container(
        width: w * 1,
        height: h * 1,
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // myTextField('ชื่อสถานที่', name_Place),
                  Text("ชื่อสถานที่", style: styleText.styleHeaderPlace),
                  SizedBox(
                    width: w * 1,
                    height: h * 0.1,
                    child: TextField(
                      controller: name_place,
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
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Urbanist'),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        dropdownMenu(type_Name, 'ประเภทสถานที่', 'type'),
                        dropdownMenu(festival_Name, 'เทศกาล', 'festival'),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        emptyBoxShow(selects_type),
                        emptyBoxShow(selects_fes),
                      ],
                    ),
                  ),
                  myTextFieldWidthMax(
                      'ข้อความอธิบาย', description_Place, 0.15, 4),
                  myTextFieldWidthMax('ที่อยู่', address_Place, 0.1, 2),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dropdownMenu(allProvince, 'จังหวัด', 'province'),
                      myTextFieldWidthMid('รหัสไปรษณีย์', noProvince, true),
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
                          height: h * 0.065,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(purpleBorder)),
                            child: Text('เลือกสถานที่'),
                            onPressed: () async {
                              var ans = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapMarkerPlace(),
                                  ));
                              if (ans == 'false') {
                              } else {
                                lat_place.text = ans.latitude.toString();
                                lng_place.text = ans.longitude.toString();
                              }
                            },
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      myTextFieldWidthMid('ละติจูด', lat_place, false),
                      myTextFieldWidthMid('ลองติจูด', lng_place, false),
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
                          height: h * 0.065,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(purpleBorder)),
                            child: Text('แก้ไขสถานที่ท่องเที่ยว'),
                            onPressed: () async {
                              if (name_place.text.isNotEmpty &&
                                  description_Place.text.isNotEmpty &&
                                  lat_place.text.isNotEmpty &&
                                  lng_place.text.isNotEmpty &&
                                  address_Place.text.isNotEmpty &&
                                  provinceValue != '' &&
                                  noProvince.text.isNotEmpty &&
                                  selects_type.isNotEmpty &&
                                  selects_fes.isNotEmpty) {
                                _showMyDialogEdit();
                              } else {
                                _showMyDialogError();
                              }
                            },
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขสถานที่ท่องเที่ยว"),
        backgroundColor: Color.fromARGB(122, 116, 63, 238),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, 'false');
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Place_Page(),
    );
  }
}
