import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:projectbdtravel/API/apiPlace.dart';
import 'package:projectbdtravel/Page/deleteTypeFes.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:projectbdtravel/Tools/style.tools.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({super.key});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final ImagePicker imagePicker = ImagePicker();
  List<String> list_SearchName = [];

  List<String> type_id = [];
  List<String> type_Name = [];
  List type = [];
  List<String> type_add = [];
  List<String> festival_id = [];
  List<String> festival_Name = [];
  List festival = [];
  List<String> festival_add = [];

  List<String> auto_type = [];
  List<String> auto_fes = [];
  List<String> allProvince = [];
  String str_type = '';
  String str_fes = '';

  Color purpleBorder = HexColor('#9C9AFC');
  Color blackBorder = Colors.black26;

  String dropdownValue = '';
  String provinceValue = '';
  List selects_type = [];
  List selects_fes = [];

  List<XFile>? imageFileList = [];

  TextEditingController name_Place = new TextEditingController();
  TextEditingController description_Place = new TextEditingController();
  TextEditingController address_Place = new TextEditingController();
  TextEditingController lat_place = new TextEditingController();
  TextEditingController lng_place = new TextEditingController();
  TextEditingController noProvince = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List_Type();
    List_Festival();
    List_Province();
    getTypePlace();
    getFestivalPlace();
  }

  // ignore: non_constant_identifier_names
  Future List_Type() async {
    try {
      var data = await ListType();
      setState(() {
        auto_type = data;
      });
    } catch (e) {
      print(e);
    }

    return auto_type;
  }

  Future List_Festival() async {
    try {
      var data = await ListFestival();
      setState(() {
        auto_fes = data;
      });
    } catch (e) {
      print(e);
    }

    return auto_fes;
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

  Future getTypePlace() async {
    type_Name.clear();
    try {
      var data = await getType();
      for (int i = 0; i < data.length; i++) {
        setState(() {
          type_Name.add(data[i]['T_Name'].toString());
        });
      }
      setState(() {
        type = data;
      });
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
      setState(() {
        festival = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Future addFesType(String id) async {
    try {
      for (int i = 0; i < selects_type.length; i++) {
        for (int j = 0; j < type.length; j++) {
          if (selects_type[i] == type[j]['T_Name']) {
            addTypeforPlace(id, type[j]['T_ID']);
          }
        }
      }
      for (int i = 0; i < selects_fes.length; i++) {
        for (int j = 0; j < festival.length; j++) {
          if (selects_fes[i] == festival[j]['F_Name']) {
            addFestivalforPlace(id, festival[j]['F_ID']);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future uploadPhoto(String ans) async {
    try {
      for (int i = 0; i < imageFileList!.length; i++) {
        UploadImagePlace(imageFileList![i].path, imageFileList![i].name);
        addImageforPlace(ans, imageFileList![i].name);
      }
    } catch (e) {
      print(e);
    }
  }

  void selectImages() async {
    if (imageFileList!.length == 5) {
      _dialogBuilderFullImage(context);
    } else {
      try {
        final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
        if (selectedImages!.isNotEmpty) {
          for (int i = 0; i < selectedImages.length; i++) {
            imageFileList!.add(selectedImages[i]);
          }
        }
        setState(() {});
      } catch (e) {}
    }
  }

  String checkList(List list, String str) {
    int ans = 0;
    for (int i = 0; i < list.length; i++) {
      if (str == list[i]) {
        ans++;
      }
    }
    return ans.toString();
  }

  Future<void> _dialogBuilderFullImage(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คำเตือน'),
          content: const Text(
              'รูปภาพครบ 5 รูปแล้ว โปรดลบออกแล้วทำรายการใหม่อีกครั้ง'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            onChanged: (value) {
              header == 'type' ? str_type = value : str_fes = value;
            },
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

    Autocomplete textAutoNamePlace() {
      return Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          return list_SearchName.where((String option) {
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
            onChanged: (value) async {
              var data = await autoPlace(value);
              for (int i = 0; i < data.length; i++) {
                setState(() {
                  list_SearchName
                      .add(data[i]["structured_formatting"]["main_text"]);
                });
              }
            },
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
                fontWeight: FontWeight.normal, fontFamily: 'Urbanist'),
          );
        },
        onSelected: (String str) {
          name_Place.text = str;
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

    Container BoxImageShow() {
      return Container(
          width: w * 0.6,
          height: h * 0.6,
          margin: EdgeInsets.all(5.0),
          //color: Colors.black,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                crossAxisCount: 3,
              ),
              itemCount: imageFileList!.length,
              itemBuilder: (context, index) {
                return InkWell(
                    splashColor: Colors.white10, // Splash color over image
                    child: Stack(
                      children: [
                        Ink.image(
                          fit: BoxFit.cover, // Fixes border issues
                          width: 100,
                          height: 100,
                          image: FileImage(File(imageFileList![index].path)),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              imageFileList!.removeAt(index);
                              setState(() {});
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ));
              },
            ),
          ));
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
                      setState(() {
                        getTypePlace();
                      });
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
                      getFestivalPlace();
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

    Container dropdownMenu(List<String> header, String head, String str) {
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

    Container emptyBoxShow(List enter) {
      return Container(
        width: w * 0.4,
        height: h * 0.4,
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

    Container Place_Page() {
      return Container(
        width: w * 1,
        height: h * 1.95,
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
                      height: h * 0.2,
                      child: textAutoNamePlace(),
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
                        'ข้อความอธิบาย', description_Place, 0.4, 5),
                    myTextFieldWidthMax('ที่อยู่', address_Place, 0.2, 2),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    HexColor('#9C9AFC'))),
                            onPressed: () {
                              selectImages();
                            },
                            child: Text(
                              'เพิ่มรูปภาพ',
                              style: TextStyle(fontFamily: 'Urbanist'),
                            )),
                        BoxImageShow(),
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
                            height: h * 0.145,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(purpleBorder)),
                              child: Text('เพิ่มสถานที่ท่องเที่ยว'),
                              onPressed: () async {
                                if (name_Place.text.isNotEmpty &&
                                    type.isNotEmpty &&
                                    imageFileList!.isNotEmpty &&
                                    festival.isNotEmpty &&
                                    description_Place.text.isNotEmpty &&
                                    address_Place.text.isNotEmpty &&
                                    provinceValue != '' &&
                                    noProvince.text.isNotEmpty &&
                                    lat_place.text.isNotEmpty &&
                                    lng_place.text.isNotEmpty) {
                                  String ans = await addPlace(
                                      'AUTO',
                                      name_Place,
                                      description_Place,
                                      '${address_Place.text} $provinceValue ${noProvince.text}',
                                      lat_place,
                                      lng_place,
                                      DateFormat('dd-MM-yyyy')
                                          .format(DateTime.now()));
                                  if (ans == 'FASLE' || ans == 'FALSE INSERT') {
                                    print('no insert');
                                  } else {
                                    addFesType(ans);
                                    uploadPhoto(ans);
                                    Timer(const Duration(seconds: 2), () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'เพิ่มสถานที่ท่องเที่ยวสำเร็จ')));
                                      Navigator.pop(context, 'true');
                                    });
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'ไม่สามารถเพิ่มข้อมูลสถานที่ท่องเที่ยวได้ กรุณาลองใหม่อีกครั้ง')));
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
          actions: [
            IconButton(
                onPressed: () async {
                  String str = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DeleteObject()));
                  if (str == 'true') {
                    getFestivalPlace();
                    getTypePlace();
                  }
                },
                icon: Icon(Icons.delete_forever))
          ],
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

class MapMarkerPlace extends StatefulWidget {
  const MapMarkerPlace({super.key});

  @override
  State<MapMarkerPlace> createState() => _MapMarkerPlaceState();
}

class _MapMarkerPlaceState extends State<MapMarkerPlace> {
  late GoogleMapController _controller;
  late Marker marker;
  List<Marker> markers = <Marker>[];
  late BitmapDescriptor customIconMe = BitmapDescriptor.defaultMarker;

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _userLocation;
  LatLng initialCameraPosition =
      const LatLng(36.865421209974606, -124.99604970216751);

  LatLng answer = const LatLng(0.00, 0.00);

  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _userLocation = await location.getLocation();
    double? latitude = _userLocation.latitude;
    double? longitude = _userLocation.longitude;

    try {
      setState(() {
        initialCameraPosition = LatLng(latitude!, longitude!);
        answer = initialCameraPosition;
        _controller
            .moveCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
        setMarkers(latitude, longitude);
        _onMapCreate(_controller);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _userLocation = await location.getLocation();
    double? latitude = _userLocation.latitude;
    double? longitude = _userLocation.longitude;

    setState(() {
      initialCameraPosition = LatLng(latitude!, longitude!);
      _controller
          .moveCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
      _onMapCreate(_controller);
    });
  }

  void _onMapCreate(GoogleMapController controller) {
    _controller = controller;
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: initialCameraPosition, zoom: 12)));
  }

  createMarker() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(3, 3)), 'img/accountMe.png')
        .then((icon) {
      setState(() {
        customIconMe = icon;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(122, 116, 63, 238),
          title: Text('เลือกตำแหน่งที่ตั้ง'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, 'false');
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(122, 116, 63, 238),
          onPressed: _getUserLocation,
          label: const Text('ค้นหาฉัน'),
          icon: const Icon(Icons.near_me),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: Stack(
          children: [
            GoogleMap(
              onTap: (LatLng latLng) {
                markers.clear();
                markers.add(Marker(
                    markerId: const MarkerId('select'), position: latLng));
                setState(() {});
                answer = latLng;
              },
              mapType: MapType.normal,
              markers: Set<Marker>.of(markers),
              initialCameraPosition:
                  CameraPosition(target: initialCameraPosition, zoom: 16),
              onMapCreated: _onMapCreate,
            ),
            Positioned(
              bottom: h * 0.055,
              right: w * 0.25,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(HexColor('#9C9AFC'))),
                  onPressed: () {
                    if (answer.latitude == 0.00 && answer.longitude == 0.00) {
                    } else {
                      Navigator.pop(context, answer);
                    }
                  },
                  child: Text(
                    'เลือกตำแหน่งนี้',
                    style: TextStyle(fontFamily: 'Urbanist'),
                  )),
            )
          ],
        ));
  }

  setMarkers(double lat, double lng) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("select"),
        position: LatLng(lat, lng),
        infoWindow: const InfoWindow(title: 'ต้องการเลือกที่อยู่ตำแหน่งนี้'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    setState(() {});
  }
}

class AddImagePage extends StatefulWidget {
  final String pid;
  const AddImagePage({Key? key, required this.pid}) : super(key: key);

  @override
  State<AddImagePage> createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  List<XFile>? imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();

  void selectImages() async {
    try {
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        imageFileList!.addAll(selectedImages);
      }
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(122, 116, 63, 238),
        title: Text('เพิ่มรูปสถานที่ท่องเที่ยว'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, "FALSE");
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        width: w * 1,
        height: h * 1,
        child: Column(children: [
          ElevatedButton(
            onPressed: () {
              selectImages();
            },
            child: Text("เพิ่มรูปภาพ"),
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Color.fromARGB(122, 116, 63, 238))),
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              width: w * 1,
              height: h * 0.35,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black12)),
              child: Scrollbar(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 3,
                    crossAxisCount: 3,
                  ),
                  itemCount: imageFileList!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        splashColor: Colors.white10, // Splash color over image
                        child: Stack(
                          children: [
                            Image(
                              fit: BoxFit.cover, // Fixes border issues
                              width: 110,
                              height: 110,
                              image:
                                  FileImage(File(imageFileList![index].path)),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  imageFileList!.removeAt(index);
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ));
                  },
                ),
              )),
          Container(
              margin: EdgeInsets.only(top: 30),
              width: w * 1,
              child: ElevatedButton(
                onPressed: () async {
                  String images = imageFileList!
                      .map<String>((xfile) => xfile.name)
                      .toList()
                      .toString()
                      .replaceAll("[", "")
                      .replaceAll("]", "");
                  String value = await addImageforPlace(widget.pid, images);
                  if (value == "TRUE") {
                    for (int i = 0; i < imageFileList!.length; i++) {
                      UploadImagePlace(
                          imageFileList![i].path, imageFileList![i].name);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('เพิ่มรูปภาพสำเร็จ')));
                    Navigator.pop(context, "TRUE");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('เพิ่มรูปภาพไม่สำเร็จ')));
                  }
                },
                child: Text("ยืนยันการเพิ่มรูปภาพ"),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(122, 116, 63, 238))),
              ))
        ]),
      ),
    );
  }
}
