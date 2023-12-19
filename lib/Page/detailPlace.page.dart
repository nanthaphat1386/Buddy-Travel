import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projectbdtravel/API/apiPlace.dart';
import 'package:projectbdtravel/Page/profile.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class DetailPlace extends StatefulWidget {
  final String id;
  const DetailPlace({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPlace> createState() => _DetailPlaceState();
}

class _DetailPlaceState extends State<DetailPlace> {
  var detail;
  String name = '';
  String description = '';
  String address = '';
  int len_image = 0;
  int len_type = 0;
  int len_festival = 0;
  int len_review = 0;
  int a = 0;
  double point = 0;
  List img = [];
  List type = [];
  List festival = [];
  SampleItem? selectedMenu;

  String id_me = '';

  late GoogleMapController _controller;
  late Marker marker;
  List<Marker> markers = <Marker>[];
  LatLng initialCameraPosition = LatLng(16.2250267, 103.2298629);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetailPlace();
    getME();
  }

  Future getDetailPlace() async {
    int p = 0;
    try {
      detail = await getPlaceID(widget.id);
      len_image = detail['P_Image'].length;
      len_type = detail['P_Type'].length;
      len_festival = detail['P_Festival'].length;
      len_review = detail['P_Review'].length;
      description = detail['P_Description'];
      address = detail['P_Address'];
      name = detail['P_Name'];
      initialCameraPosition =
          LatLng(double.parse(detail['P_Lat']), double.parse(detail['P_Lng']));
      _onMapCreate(_controller);
      setMarkers(double.parse(detail['P_Lat']), double.parse(detail['P_Lng']));
      for (int i = 0; i < len_image; i++) {
        setState(() {
          img.add(detail['P_Image'][i].toString());
        });
      }
      for (int i = 0; i < len_type; i++) {
        setState(() {
          type.add(detail['P_Type'][i].toString());
        });
      }
      for (int i = 0; i < len_festival; i++) {
        setState(() {
          festival.add(detail['P_Festival'][i].toString());
        });
      }
      for (int i = 0; i < len_review; i++) {
        p = p + int.parse(detail['P_Review'][i]['R_Point']);
      }
      point = p / len_review;
    } catch (e) {
      print(e);
    }
  }

  getME() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      id_me = _prefs.getString('id').toString();
    });
  }

  void _onMapCreate(GoogleMapController controller) {
    _controller = controller;
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: initialCameraPosition, zoom: 12)));
  }

  Future addReview() async {}

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 0.95 * h,
            width: w,
            child: Stack(
              children: [
                PageView.builder(
                    itemCount: img.length,
                    pageSnapping: true,
                    padEnds: false,
                    itemBuilder: (context, pagePosition) {
                      return Container(
                          child: Image.network(
                        img[pagePosition],
                        fit: BoxFit.fill,
                      ));
                    }),
                Positioned(
                  left: w * 0.02,
                  top: h * 0.02,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(150, 255, 255, 255)),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    ),
                  ),
                ),
                Positioned(
                  right: w * 0.18,
                  top: h * 0.02,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(132, 255, 255, 255)),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.share, color: Colors.black),
                    ),
                  ),
                ),
                Positioned(
                  right: w * 0.02,
                  top: h * 0.02,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(132, 255, 255, 255)),
                    child: PopupMenuButton<SampleItem>(
                      initialValue: selectedMenu,
                      // Callback that sets the selected popup menu item.
                      onSelected: (SampleItem item) {
                        setState(() {
                          selectedMenu = item;
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<SampleItem>>[
                        const PopupMenuItem<SampleItem>(
                          value: SampleItem.itemOne,
                          child: Text(
                            'แก้ไขสถานที่',
                          ),
                        ),
                        const PopupMenuItem<SampleItem>(
                          value: SampleItem.itemTwo,
                          child: Text(
                            'ประวัติการแก้ไข',
                          ),
                        ),
                        const PopupMenuItem<SampleItem>(
                          value: SampleItem.itemThree,
                          child: Text(
                            'ปิดการใช้งานของสถานที่',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  left: w * 0.025,
                  right: w * 0.025,
                  top: h * 0.02,
                  bottom: h * 0.02),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: w * 0.05, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.bookmark_border,
                            color: Color.fromARGB(122, 116, 63, 238)),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      box(point.toStringAsFixed(1)),
                      Padding(
                        padding: EdgeInsets.only(left: w * 0.01),
                        child: Text(
                          '( ' + len_review.toString() + ' รีวิว)',
                          style: TextStyle(
                              fontSize: w * 0.0375,
                              color: Color.fromARGB(255, 116, 115, 115)),
                        ),
                      )
                    ],
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(
                left: w * 0.025,
                right: w * 0.025,
                top: h * 0.02,
                bottom: h * 0.02),
            child: boxDescription(description),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.spaceAround,
              direction: Axis.horizontal,
              runSpacing: 3,
              children: [
                boxButton(
                    'เขียนรีวิว',
                    Icon(
                      Icons.reviews_sharp,
                      color: Colors.white,
                    ),
                    addReview()),
                boxButton(
                    'เพิ่มรูป',
                    Icon(
                      Icons.camera_enhance,
                      color: Colors.white,
                    ),
                    addReview()),
                boxButton(
                    'เช็คอิน',
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    addReview()),
              ],
            ),
          ),
          DefaultTabController(
            length: 2, // length of tabs
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
                        Tab(text: 'ข้อมูลสถานที่'),
                        Tab(text: 'การรีวิว'),
                      ],
                    ),
                  ),
                  Container(
                      color: Colors.transparent,
                      height: h * 1, //height of TabBarView
                      padding: EdgeInsets.only(top: 5),
                      child: TabBarView(children: <Widget>[
                        ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              height: h * 0.60,
                              child: Expanded(
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  markers: Set<Marker>.of(markers),
                                  initialCameraPosition: CameraPosition(
                                      target: initialCameraPosition, zoom: 14),
                                  onMapCreated: _onMapCreate,
                                ),
                              ),
                            ),
                            Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.location_on,
                                  color: Color.fromARGB(167, 81, 69, 250),
                                ),
                                title: Text(
                                  address,
                                  style: TextStyle(fontSize: w * 0.035),
                                ),
                              ),
                            ),
                            Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.home,
                                  color: Color.fromARGB(167, 81, 69, 250),
                                ),
                                title: Text(
                                  type
                                      .toString()
                                      .replaceAll('[', '')
                                      .replaceAll(']', ''),
                                  style: TextStyle(fontSize: w * 0.035),
                                ),
                              ),
                            ),
                            Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.festival_rounded,
                                  color: Color.fromARGB(167, 81, 69, 250),
                                ),
                                title: Text(
                                  festival
                                      .toString()
                                      .replaceAll('[', '')
                                      .replaceAll(']', ''),
                                  style: TextStyle(fontSize: w * 0.035),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(10))
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.only(bottom: 10, top: 5),
                            child: ListView(
                              children: [
                                for (int i = 0; i < len_review; i++)
                                  ListTile(
                                    leading: InkWell(
                                      onTap: () {
                                        if (detail['P_Review'][i]['R_MID'] ==
                                            id_me) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Profile(
                                                      id: detail['P_Review'][i]
                                                          ['R_MID'],
                                                      info: 'me')));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Profile(
                                                      id: detail['P_Review'][i]
                                                          ['R_MID'],
                                                      info: 'other')));
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            detail['P_Review'][i]['R_Image'],
                                            scale: 1.0),
                                      ),
                                    ),
                                    title: Wrap(
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(detail['P_Review'][i]['R_Name'] +
                                            ' ' +
                                            detail['P_Review'][i]['R_Point']),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        )
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(detail['P_Review'][i]['R_Text']),
                                        Container(
                                          height: detail["P_Review"][i]
                                                          ["R_ImageReview"]
                                                      .length <=
                                                  0
                                              ? 0
                                              : detail["P_Review"][i]
                                                              ["R_ImageReview"]
                                                          .length <
                                                      4
                                                  ? h * 0.275
                                                  : h * 0.65,
                                          child: GridView.count(
                                            // Create a grid with 2 columns. If you change the scrollDirection to
                                            // horizontal, this produces 2 rows.
                                            crossAxisCount: 3,
                                            // Generate 100 widgets that display their index in the List.
                                            children: List.generate(
                                                detail["P_Review"][i]
                                                        ["R_ImageReview"]
                                                    .length, (index) {
                                              return Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Image(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      detail["P_Review"][i]
                                                              ["R_ImageReview"]
                                                          [index],
                                                      scale: 1.0),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(10))
                                      ],
                                    ),
                                    trailing: Icon(
                                      Icons.favorite_rounded,
                                      color: Color.fromARGB(122, 116, 63, 238),
                                    ),
                                  ),
                                Divider(height: 0),
                              ],
                            )),
                      ]))
                ]),
          ),
        ],
      ),
    );
  }

  Container box(String str) {
    double w = displayWidth(context);
    double h = displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Container(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        //width: 0.15 * w,
        height: 0.075 * h,
        alignment: Alignment.center,
        decoration: myBoxDecoration(Color.fromARGB(137, 116, 63, 238)),
        child: Row(
          children: [
            Text(
              str,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: Colors.white),
            ),
            Icon(
              Icons.star,
              color: Colors.white,
              size: w * 0.0375,
            )
          ],
        ));
  }

  InkWell boxButton(String str, Icon icon, Future onclick) {
    double w = displayWidth(context);
    double h = displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return InkWell(
      onTap: () {
        onclick;
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          height: 0.13 * h,
          width: 0.275 * w,
          alignment: Alignment.center,
          decoration: myBoxDecoration(Color.fromARGB(122, 116, 63, 238)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              Text(
                ' ' + str,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.5, color: Colors.white),
              ),
            ],
          )),
    );
  }

  Container boxDescription(String str) {
    double w = displayWidth(context);
    double h = displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      alignment: Alignment.topLeft,
      decoration: myBoxDecoration(Color.fromARGB(137, 116, 63, 238)),
      child: Text(
        str,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 13.5, color: Colors.white),
      ),
    );
  }

  BoxDecoration myBoxDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius:
          BorderRadius.all(Radius.circular(5.0) //     <--- border radius here
              ),
    );
  }

  setMarkers(double lat, double lng) {
    markers.add(
      Marker(
        markerId: MarkerId(name),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: name),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    setState(() {});
  }
}
