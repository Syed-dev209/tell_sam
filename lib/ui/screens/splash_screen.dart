import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tell_sam/data/models/location_model.dart';
import 'package:tell_sam/data/storage_service.dart';
import 'package:tell_sam/ui/screens/home/homepage.dart';
import 'package:tell_sam/ui/screens/location/location_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkLocation() async {
    var data = await StorageServices().getData('location');
    log(data.toString());
    if (data != null && data != '') {
      LocationsModelData locationsModelData = LocationsModelData.fromJson(data);
      LocationsModelData.selectedLocation = locationsModelData;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    selectedLocation: locationsModelData,
                  )));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LocationsScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    checkLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/logo.jpg',
                  height: 250.h,
                  //width: 600.w,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            LinearProgressIndicator(
              backgroundColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
