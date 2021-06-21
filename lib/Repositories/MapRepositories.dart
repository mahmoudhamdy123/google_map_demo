import 'package:google_map_demo/API/mapApi.dart';
import 'package:google_map_demo/models/APIResultModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter_example/Application.dart';



class MapRepository{
  Future<APIResultModel> getRouteCoordinates(LatLng l1, LatLng l2) {
    return API.getRouteCoordinates({
      'origin': '${l1.latitude},${l1.longitude}',
      'destination': '${l2.latitude},${l2.longitude}',
      //TODO You must enable Billing on the Google Cloud Project at https://console.cloud.google.com/project/_/billing/enable Learn more at https://developers.google.com/maps/gmp-get-started
      // 'key': Application.GOOGLE_MAPS_API_KEY,
    });
  }
}