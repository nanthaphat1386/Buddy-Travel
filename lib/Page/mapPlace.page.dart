import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:projectbdtravel/API/apiPlace.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mapPlace extends StatefulWidget {
  const mapPlace({super.key});

  @override
  State<mapPlace> createState() => _mapPlaceState();
}

class _mapPlaceState extends State<mapPlace> {
  late GoogleMapController _controller;
  late Marker marker;
  List<Marker> markers = <Marker>[];
  late BitmapDescriptor customIconMe = BitmapDescriptor.defaultMarker;

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _userLocation;
  LatLng initialCameraPosition =
      const LatLng(36.865421209974606, -124.99604970216751);

  String name = '';
  String img = '';
  String ID = '';

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
        _controller
            .moveCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
        getMeMarkers("me", "Me", latitude, longitude);
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
    getProfile();
  }

  getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        img = prefs.getString('image').toString();
        ID = prefs.getString('id').toString();
        name = prefs.getString('fName').toString() +
            ' ' +
            prefs.getString('lName').toString();
      });
    } catch (e) {
      print(e);
    }
    _getCheckinFriend();
  }

  Future<void> _getCheckinFriend() async {
    try {
      var fr = await getCheckinMap(ID);
      for (int i = 0; i < fr.length; i++) {
        print(double.parse(fr[i]["lng"]));
        setState(() {
          getMeMarkers(fr[i]["P_ID"], fr[i]["P_Name"],
              double.parse(fr[i]["lat"]), double.parse(fr[i]["lng"]));
        });
      }
      print(fr);
      print(fr.runtimeType);
    } catch (e) {
      print(e);
    }
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

  createMarker() async {
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
    double h = displayHeight(context) -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _getUserLocation,
          label: const Text('ค้นหาฉัน'),
          icon: const Icon(Icons.near_me),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: Stack(
          children: [
            GoogleMap(
              onTap: (LatLng latLng) {},
              mapType: MapType.normal,
              markers: Set<Marker>.of(markers),
              initialCameraPosition:
                  CameraPosition(target: initialCameraPosition, zoom: 14),
              onMapCreated: _onMapCreate,
            ),
            // (markers.isNotEmpty)
            //     ? Positioned(
            //         child: Align(
            //         alignment: FractionalOffset.bottomCenter,
            //         child: Container(
            //           height: h * 0.4,
            //           width: w,
            //           color: Colors.white,
            //           alignment: Alignment.bottomCenter,
            //           margin:
            //               EdgeInsets.fromLTRB(w * 0.05, 0, w * 0.05, h * 0.35),
            //         ),
            //       ))
            //     : Container(),
          ],
        ));
  }

  setMarkers(double lat, double lng) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("Search"),
        position: LatLng(lat, lng),
        infoWindow: const InfoWindow(title: 'New Search'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    setState(() {});
  }

  getMeMarkers(String id, String name, double lat, double lng) {
    // createMarker();
    // markers.clear();
    createMarker();
    markers.add(
      Marker(
        markerId: MarkerId(id),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: name),
        icon: customIconMe,
      ),
    );
    setState(() {});
    print(markers);
  }
}
