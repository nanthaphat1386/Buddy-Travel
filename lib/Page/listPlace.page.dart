import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:projectbdtravel/API/apiPlace.dart';
import 'package:projectbdtravel/Page/addPlace.page.dart';
import 'package:projectbdtravel/Page/detailPlace.page.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:carousel_slider/carousel_slider.dart';

class listPlace extends StatefulWidget {
  const listPlace({super.key});

  @override
  State<listPlace> createState() => _listPlaceState();
}

class _listPlaceState extends State<listPlace> {
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _userLocation;
  LatLng initialCameraPosition =
      const LatLng(36.865421209974606, -124.99604970216751);

  List Place = [];
  int len_image = 0;
  List<Image> img = [];
  List<String> split_address = [];
  List address = [];
  Map<int, List<Image>> len_img = {};

  @override
  void initState() {
    // TODO: implement initState
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
    });
    try {
      allPlace(latitude!.toString(), longitude!.toString());
    } catch (e) {}
  }

  Future<List> allPlace(String lati, String long) async {
    try {
      Place = await getPlace(lati, long);
      for (int i = 0; i < Place.length; i++) {
        split_address = Place[i]['P_Address'].toString().split(' ');
        address.add(split_address[split_address.length - 2]);
        len_image = Place[i]['P_Image'].length;
        for (int m = 0; m < len_image; m++) {
          img.add(Image.network(Place[i]['P_Image'][m].toString()));
          len_img[i] = img;
        }
        img = [];
      }
    } catch (e) {
      print(e);
    }
    return Place;
  }

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayWidth(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Scaffold(
        appBar: AppBar(
          title: Text('สถานที่'),
          backgroundColor: HexColor('#9C9AFC'),
          actions: [
            IconButton(
                onPressed: () async {
                  String refresh = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPlace()));
                  if (refresh == 'true') {
                    allPlace(initialCameraPosition.latitude.toString(),
                        initialCameraPosition.longitude.toString());
                    setState(() {});
                  }
                },
                icon: Icon(Icons.add_home_work_sharp))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: HexColor('#859C9AFC'),
          onPressed: () {},
          shape: CircleBorder(),
          child: const Icon(Icons.search),
        ),
        backgroundColor: Colors.grey.shade300,
        body: Column(
          children: [
            Padding(padding: EdgeInsets.all(5)),
            Expanded(
              child: FutureBuilder(
                  future: allPlace(
                      initialCameraPosition.latitude.toString(),
                      initialCameraPosition.longitude
                          .toString()), // a previously-obtained Future<String> or null
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (ConnectionState.active != null && !snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Scrollbar(
                        child: ListView.builder(
                            itemCount: Place.length,
                            itemBuilder:
                                (BuildContext buildContext, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 3),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: h * 0.75,
                                        width: w,
                                        child: CarouselSlider(
                                            items: len_img[index],
                                            options: CarouselOptions(
                                              height: h * 1.25,
                                              aspectRatio: 16 / 9,
                                              viewportFraction: 0.8,
                                              initialPage: 0,
                                              enableInfiniteScroll: true,
                                              reverse: false,
                                              autoPlay: false,
                                              //autoPlayInterval: Duration(seconds: 3),
                                              //autoPlayAnimationDuration: Duration(milliseconds: 800),
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enlargeCenterPage: true,
                                              scrollDirection: Axis.horizontal,
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    Place[index]['P_Name'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: w * 0.015,
                                                ),
                                                Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    //padding: EdgeInsets.all(2),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5.5),
                                                      child: Text(
                                                        '${Place[index]['distance']} Km.',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10),
                                                      ),
                                                    )),
                                              ],
                                            )),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text(Place[index]
                                                          ['P_CountReview'] +
                                                      ' '),
                                                  Icon(
                                                    Icons.reviews,
                                                    color: HexColor('#9C9AFC'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 2, 10, 2),
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                'ประเภท ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                              for (int i = 0;
                                                  i <
                                                      Place[index]['P_Type']
                                                          .length;
                                                  i++)
                                                Wrap(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 5),
                                                      child: box(Place[index]
                                                          ['P_Type'][i]),
                                                    )
                                                  ],
                                                ),
                                              //
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 2, 10, 2),
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                'เทศกาล ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                              for (int i = 0;
                                                  i <
                                                      Place[index]['P_Festival']
                                                          .length;
                                                  i++)
                                                Wrap(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 5),
                                                      child: box(Place[index]
                                                          ['P_Festival'][i]),
                                                    ),
                                                  ],
                                                )
                                              //
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Icon(
                                                  Icons.location_on_outlined,
                                                  size: 20,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 2),
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  address[index],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          )),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            alignment: Alignment(1, -1),
                                            child: ButtonTheme(
                                              minWidth: 0.35 * w,
                                              height: 0.075 * h,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  String ans = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailPlace(
                                                                  id: Place[
                                                                          index]
                                                                      [
                                                                      'P_ID'])));
                                                  if (ans == 'TRUE') {
                                                    setState(() {
                                                      allPlace(
                                                          initialCameraPosition
                                                              .latitude
                                                              .toString(),
                                                          initialCameraPosition
                                                              .longitude
                                                              .toString());
                                                    });
                                                  } else {
                                                    setState(() {
                                                      allPlace(
                                                          initialCameraPosition
                                                              .latitude
                                                              .toString(),
                                                          initialCameraPosition
                                                              .longitude
                                                              .toString());
                                                    });
                                                  }
                                                },
                                                child: const Text(
                                                  'เยี่ยมชม',
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    primary:
                                                        HexColor('#9C9AFC'),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 30,
                                                            vertical: 10),
                                                    textStyle: TextStyle(
                                                      fontSize: 15,
                                                    )),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }));
                  }),
            )
          ],
        ));
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
      decoration: myBoxDecoration(HexColor('#9C9AFC')),
      child: Text(
        str,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12.5, color: Colors.white),
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
}
