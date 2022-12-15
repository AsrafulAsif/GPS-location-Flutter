import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:location/location.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String lat = '';
  String long = '';
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionStatus;
  late LocationData _locationData;
  getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
    }
    _locationData = await location.getLocation();
    log(_locationData.toString());
    return _locationData;
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(_locationData.latitude.toString()),
            // Text(_locationData.longitude.toString()),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    getLocation();
                  },
                  child: const Text('Click')),
            ),
          ],
        ),
      ),
    );
  }
}
