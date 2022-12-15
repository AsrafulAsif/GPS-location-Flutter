import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutterlocation/home_page.dart';
import 'package:geolocator/geolocator.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Homepage());
  }
}

//home page code
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //location


  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    OverlayState? overlaySate = Overlay.of(context);
    servicestatus = await Geolocator.isLocationServiceEnabled();
    log(servicestatus.toString());
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
      showTopSnackBar(
        overlaySate!,
        const CustomSnackBar.error(
          message:
              "Something went wrong. Please check your credentials and try again",
        ),
      );
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    // LocationSettings locationSettings = const LocationSettings(
    //   accuracy: LocationAccuracy.high, //accuracy of the location data
    //   distanceFilter: 100, //minimum distance (measured in meters) a
    //   //device must move horizontally before an update event is generated;
    // );

    // StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
    //     locationSettings: locationSettings).listen((Position position) {
    //   print(position.longitude); //Output: 80.24599079
    //   print(position.latitude); //Output: 29.6593457

    //   long = position.longitude.toString();
    //   lat = position.latitude.toString();

    //   setState(() {
    //     //refresh UI on update
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Get GPS Location"),
            backgroundColor: Colors.redAccent),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(50),
            child: Column(children: [
              Text(servicestatus ? "GPS is Enabled" : "GPS is disabled."),
              Text(haspermission ? "GPS is Enabled" : "GPS is disabled."),
              Text("Longitude: $long", style: const TextStyle(fontSize: 20)),
              Text(
                "Latitude: $lat",
                style: const TextStyle(fontSize: 20),
              )
            ])));
  }
}
