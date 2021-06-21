import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapCustomizationLightDark extends StatefulWidget {
  const MapCustomizationLightDark({Key? key}) : super(key: key);

  @override
  _MapCustomizationLightDarkState createState() => _MapCustomizationLightDarkState();
}

class _MapCustomizationLightDarkState extends State<MapCustomizationLightDark> {

  Completer<GoogleMapController> _controller = Completer();
  final LatLng initialLatLng = LatLng(30.029585, 31.022356);
  //Declare Strings that will hold your style's json and a bool to control which mode is shown on the map
  bool mapDarkMode = true;
  late String _darkMapStyle;
  late String _lightMapStyle;




  // declare the styles
  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/mapStyle/dark.json');
    _lightMapStyle = await rootBundle.loadString('assets/mapStyle/light.json');
  }


  Future _setMapStyle() async {
    final controller = await _controller.future;
    if (mapDarkMode)
      controller.setMapStyle(_darkMapStyle);
    else
      controller.setMapStyle(_lightMapStyle);
  }

  @override
  void initState() {
    _loadMapStyles();
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "MapCustomizationLightDark"
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [

          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialLatLng,
              zoom: 14.47,
            ),
            onMapCreated: (GoogleMapController controller){
              //After creating the map, set the style
              _controller.complete(controller);
              _setMapStyle();
            },

          ),
          Positioned(
              top: 100,
              right: 30,
              child: Container(
                height: 30,
                width: 30,
                child: IconButton(
                  icon: Icon(
                    mapDarkMode ? Icons.brightness_4 : Icons.brightness_5,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      mapDarkMode = !mapDarkMode;
                      _setMapStyle();
                    });
                  },
                ),
              )),
        ],
      ),
    );
  }
}
