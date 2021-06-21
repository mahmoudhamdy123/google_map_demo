import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';



class LocationUpdates extends StatefulWidget {
  const LocationUpdates({Key? key}) : super(key: key);

  @override
  _LocationUpdatesState createState() => _LocationUpdatesState();
}


const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932,-71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685,-122.0605916);


class _LocationUpdatesState extends State<LocationUpdates> {


  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();

  // for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  //TODO set Google API Key
  String googleAPIKey = "GoogleAPIKey";

  // for my custom marker pins
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;

  // the user's initial location and current location
  // as it moves
  late LocationData currentLocation;

  // a reference to the destination location
  late LocationData destinationLocation;
  // wrapper around the location API
  late Location location;

  @override
  void initState() {

    // create an instance of Location
    location = new Location();
    polylinePoints = PolylinePoints();
    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      updatePinOnMap();
    });

    // set custom marker pins
    setSourceAndDestinationIcons();

    // set custom marker pins
    setSourceAndDestinationIcons();

    super.initState();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/icon1.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/icon1.png');
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }


  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition = LatLng(currentLocation.latitude!,
        currentLocation.longitude!);
    // get a LatLng out of the LocationData object
    var destPosition = LatLng(destinationLocation.latitude!,
        destinationLocation.longitude!);
    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon
    ));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon
    ));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }

  void setPolylines() async {

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(currentLocation.latitude!, currentLocation.longitude!),
        PointLatLng(destinationLocation.latitude!, destinationLocation.longitude!),
       );

    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point){
        polylineCoordinates.add(
            LatLng(point.latitude,point.longitude)
        );
      });
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates
        ));
      });
    }

  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude!,
          currentLocation.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(currentLocation.latitude!,
          currentLocation.longitude!);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere(
              (m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: sourceIcon
      ));
    });

  }



  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION
    );
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude!,
              currentLocation.longitude!),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Real-time Location Updates on Google Maps"
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        markers: _markers,
        polylines: _polylines,
        mapType: MapType.normal,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
          // my map has completed being created;
          // i'm ready to show the pins on the map
          showPinsOnMap();


        },

      ),
    );
  }
}
