import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:projectbdtravel/API/apiPlace.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';

class DeleteObject extends StatefulWidget {
  const DeleteObject({super.key});

  @override
  State<DeleteObject> createState() => _DeleteObjectState();
}

class _DeleteObjectState extends State<DeleteObject> {
  Color purpleBorder = HexColor('#9C9AFC');
  List<String> auto_type = [];
  List<String> auto_fes = [];
  List Type = [];
  List Festival = [];
  String str_type = '';
  String str_fes = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAutoType();
    getAutoFestival();
  }

  void getAutoType() async {
    Type = await getType();
    for (int i = 0; i < Type.length; i++) {
      setState(() {
        auto_type.add(Type[i]['T_Name'].toString());
      });
    }
  }

  void getAutoFestival() async {
    Festival = await getFestival();
    for (int i = 0; i < Festival.length; i++) {
      setState(() {
        auto_fes.add(Festival[i]['F_Name'].toString());
      });
    }
  }

  Future removeType(String str) async {
    String process = '';
    for (int i = 0; i < Type.length; i++) {
      if (Type[i]['T_Name'].toString() == str) {
        process = await deleteType(Type[i]['T_ID'].toString(), str);
      }
    }
    print(process);
    return process;
  }

  Future removeFestival(String str) async {
    String process = '';
    for (int i = 0; i < Festival.length; i++) {
      if (Festival[i]['F_Name'].toString() == str) {
        process = await deleteFestival(Festival[i]['F_ID'].toString(), str);
      }
    }
    print(process);
    return process;
  }

  Future<void> _showMyDialog(String ans) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ans == 'TRUE' ? 'สำเร็จ' : 'ไม่สำเร็จ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(ans == 'TRUE'
                    ? 'ลบรายการข้อมูลสำเร็จ'
                    : 'กรุณาตรวจสอบรายการอีกครั้ง'),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 127, 97, 248))),
                  onPressed: () async {
                    String ans = await removeType(str_type);
                    if (ans == 'TRUE') {
                      _showMyDialog('TRUE');
                    }
                    Navigator.pop(context);
                  },
                  child: Text('ตกลง')),
            )
          ],
        );
      },
    );
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
                          MaterialStatePropertyAll(Colors.redAccent)),
                  onPressed: () async {
                    String ans = await removeType(str_type);
                    if (ans == 'TRUE') {
                      setState(() {
                        getAutoFestival();
                        getAutoType();
                      });
                      _showMyDialog('TRUE');
                    } else {
                      _showMyDialog(ans);
                    }
                  },
                  child: Text('ลบประเภทสถานที่'))
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
                          MaterialStatePropertyAll(Colors.redAccent)),
                  onPressed: () async {
                    String ans = await removeFestival(str_fes);
                    if (ans == 'TRUE') {
                      setState(() {
                        getAutoFestival();
                        getAutoType();
                      });
                      _showMyDialog(ans);
                    } else {
                      _showMyDialog(ans);
                    }
                  },
                  child: Text('ลบเทศกาล'))
            ],
          ));
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ลบข้อมูล'),
          backgroundColor: Color.fromARGB(122, 116, 63, 238),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, 'true');
              },
              icon: Icon(Icons.arrow_back_ios)),
          bottom: const TabBar(
            tabs: <Widget>[
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
            Type_Page(),
            Festival_Page(),
          ],
        ),
      ),
    );
  }
}
