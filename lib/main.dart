import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_demo/screens/AddingCustomMarker.dart';
import 'package:google_map_demo/screens/DrawingRoutes.dart';
import 'package:google_map_demo/screens/MapCustomizationLightDark.dart';
import 'package:google_map_demo/screens/locationUpdates.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Google Map Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddingCustomMarker()));

            },
            child: Container(
              width: width*0.8,
              height:height*0.1,
              margin: EdgeInsets.all(5),
              child: Center(child: Text("Adding Custom Marker To the map",style:TextStyle(color: Colors.white)),),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MapCustomizationLightDark()));
            },
            child: Container(
              width: width*0.8,
              height:height*0.1,
              margin: EdgeInsets.all(5),
              child: Center(child: Text("Map Customization (Light/Dark mode)",style:TextStyle(color: Colors.white)),),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DrawingRoutes()));
            },
            child: Container(
              width: width*0.8,
              height:height*0.1,
              margin: EdgeInsets.all(5),
              child: Center(child: Text("Drawing routes",style:TextStyle(color: Colors.white)),),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationUpdates()));
            },
            child: Container(
              width: width*0.8,
              height:height*0.1,
              margin: EdgeInsets.all(5),
              child: Center(child: Text("Real-time Location Updates on Google Maps",style:TextStyle(color: Colors.white)),),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
          )




        ],
      ) ,  // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
