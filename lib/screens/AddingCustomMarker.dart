import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




class AddingCustomMarker extends StatefulWidget {
  const AddingCustomMarker({Key? key}) : super(key: key);

  @override
  _AddingCustomMarkerState createState() => _AddingCustomMarkerState();
}

class _AddingCustomMarkerState extends State<AddingCustomMarker> {

  Completer<GoogleMapController> _controller = Completer();
  final LatLng initialLatLng = LatLng(30.029585, 31.022356);
  //Declare a BitmapDescriptor which will hold the customIcon
  late BitmapDescriptor customIcon;
  //Declare a Set of Markers
  Set<Marker> _markers = Set<Marker>();


  // function the map will be updated with the given markers
  _setMapPins(List<LatLng> markersLocation) {
    _markers.clear();
    setState(() {
      markersLocation.forEach((markerLocation) {
        _markers.add(Marker(
          markerId: MarkerId(markerLocation.toString()),
          position: markerLocation,
          icon: customIcon,
        ));
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //Assign the needed png to the customIcon
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(100, 100)),
        'assets/images/icon1.png')
        .then((icon) {
      customIcon = icon;
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AddingCustomMarker"
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: initialLatLng,
          zoom: 14.47,
        ),
        onMapCreated: (GoogleMapController controller){
          //set of markers after the map is created in onMapCreated
          _controller.complete(controller);
          _setMapPins([LatLng(30.029585, 31.022356)]);
        },

      ),
    );
  }
}
