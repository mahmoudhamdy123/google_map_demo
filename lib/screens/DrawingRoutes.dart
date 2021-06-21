import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_demo/Repositories/MapRepositories.dart';
import 'package:google_map_demo/Utils/MapUtils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class DrawingRoutes extends StatefulWidget {
  const DrawingRoutes({Key? key}) : super(key: key);

  @override
  _DrawingRoutesState createState() => _DrawingRoutesState();
}

class _DrawingRoutesState extends State<DrawingRoutes> {

  Completer<GoogleMapController> _controller = Completer();
  double lat =30.029585;
  double lng =31.022356;
  //Declare your start and end points
  final LatLng initialLatLng = LatLng(30.029585, 31.022356);
  final LatLng destinationLatLng = LatLng(30.060567, 30.962413);
  //Declare polyline and polylineCoordinates
  Set<Polyline> _polyline = {};
  List<LatLng> polylineCoordinates = [];







  _addPolyLines() {
    setState(() {
      lat = (initialLatLng.latitude + destinationLatLng.latitude)/2;
      lng = (initialLatLng.longitude + destinationLatLng.longitude)/2;
      _moveCamera(13.0);
      _setPolyLine();
    });
  }


  _moveCamera(double? zoom) async {
    final CameraPosition myPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: zoom ?? 14.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(myPosition));
  }

  _setPolyLine() async {
    final result = await MapRepository()
        .getRouteCoordinates(initialLatLng, destinationLatLng);
    final route = result.data["routes"][0]["overview_polyline"]["points"];
    setState(() {
      _polyline.add(Polyline(
          polylineId: PolylineId("tripRoute"),
          //pass any string here
          width: 3,
          geodesic: true,
          //Then we translate the results to a polyline using the MapUtils
          points: MapUtils.convertToLatLng(MapUtils.decodePoly(route)),
          color: Theme.of(context).primaryColor));
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "DrawingRoutes"
        ),
        centerTitle: true,
      ),
      body: GoogleMap(

        initialCameraPosition: CameraPosition(
          target: initialLatLng,
          zoom: 14.47,
        ),
        onMapCreated: (GoogleMapController controller){
          //After creating the map, set the polyline
          _controller.complete(controller);
          _addPolyLines();

        },

      ),
    );
  }
}
