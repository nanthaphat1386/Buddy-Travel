import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:projectbdtravel/Tools/responsive.tools.dart';

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
        getMeMarkers(latitude, longitude);
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

  final TextEditingController _searchPlace = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = displayWidth(context);
    double h = displayWidth(context) -
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
              onTap: (LatLng latLng) {
                markers.add(
                    Marker(markerId: const MarkerId('mark'), position: latLng));
                setState(() {});
              },
              mapType: MapType.normal,
              markers: Set<Marker>.of(markers),
              initialCameraPosition:
                  CameraPosition(target: initialCameraPosition, zoom: 14),
              onMapCreated: _onMapCreate,
            ),
            Positioned(
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(w * 0.05, h * 0.25, w * 0.05, h * 0.10),
                child: SizedBox(
                  height: h * 0.2,
                  child: TextFormField(
                    cursorColor: Colors.black,
                    style: const TextStyle(fontSize: 18),
                    controller: _searchPlace,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        hintText: 'ค้นหาสถานที่',
                        filled: true,
                        fillColor: Color.fromARGB(162, 255, 255, 255),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(),
                        ),
                        suffix: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search, size: h * 0.1),
                          enableFeedback: true,
                        )),
                    onChanged: (value) {},
                  ),
                ),
              ),
            ),
            (markers.isNotEmpty)
                ? Positioned(
                    child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      height: h * 0.4,
                      width: w,
                      color: Colors.white,
                      alignment: Alignment.bottomCenter,
                      margin:
                          EdgeInsets.fromLTRB(w * 0.05, 0, w * 0.05, h * 0.35),
                    ),
                  ))
                : Container(),
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

  getMeMarkers(double lat, double lng) {
    createMarker();
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("Search"),
        position: initialCameraPosition,
        infoWindow: const InfoWindow(title: 'New Search'),
        icon: customIconMe,
      ),
    );
    setState(() {});
  }
}
