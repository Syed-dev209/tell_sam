import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tell_sam/constants/constants.dart';
import 'package:tell_sam/controllers/base_service.dart';
import 'package:tell_sam/data/models/location_model.dart';
import 'package:tell_sam/data/storage_service.dart';
import 'package:tell_sam/ui/screens/home/homepage.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  LocationsModelData? selectedLocationModel;
  late StreamController<LocationsModel?> streamController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  getLocations() {
    getAllLocations().then((value) {
      streamController.add(value);
      return value;
    });
  }

  @override
  void initState() {
    super.initState();
    streamController = StreamController<LocationsModel?>();
    getLocations();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(
                  height: 40.h,
                ),
                StreamBuilder<LocationsModel?>(
                    stream: streamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data == null) {
                        return Center(
                          child: Text('No locations found'),
                        );
                      }
                      LocationsModel allLocation = snapshot.data!;
                      return Form(
                        key: formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 400.w),
                          child: SearchField<LocationsModelData>(
                            suggestionDirection: SuggestionDirection.up,
                            suggestions: allLocation.data!
                                .map((e) =>
                                    SearchFieldListItem<LocationsModelData>(
                                        e?.locationName ?? '',
                                        item: e))
                                .toList(),
                            onSuggestionTap: (value) {
                              FocusScope.of(context).unfocus();
                              selectedLocationModel = value.item;
                              StorageServices().insertData(
                                  'location', selectedLocationModel!.toJson());
                              LocationsModelData.selectedLocation =
                                  selectedLocationModel!;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(
                                          selectedLocation:
                                              selectedLocationModel!)));
                            },
                            suggestionState: Suggestion.expand,
                            textInputAction: TextInputAction.next,
                            hint: 'Please enter location',
                            hasOverlay: true,
                            searchStyle: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black.withOpacity(0.8),
                            ),
                            validator: (x) {
                              if (!allLocation.data!.any(
                                      (item) => item!.locationName! == x) ||
                                  x!.isEmpty) {
                                return 'Please enter a valid location';
                              }
                              return null;
                            },
                            searchInputDecoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                            maxSuggestionsInViewPort: 6,
                            itemHeight: 50,
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
