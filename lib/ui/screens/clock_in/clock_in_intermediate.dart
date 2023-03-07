import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tell_sam/controllers/base_service.dart';
import 'package:tell_sam/data/models/location_model.dart';
import 'package:tell_sam/data/models/staff_model.dart';
import 'package:tell_sam/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tell_sam/ui/screens/clock_in/clock_in.dart';
import 'package:tell_sam/ui/screens/clock_in/clock_in_success.dart';
import 'package:tell_sam/ui/screens/clock_out/clock_out_success.dart';

class ClockInIntermediary extends StatefulWidget {
  final StaffsModelData user;
  final Entry type;
  const ClockInIntermediary(
      {required this.user, required this.type, super.key});

  @override
  State<ClockInIntermediary> createState() => _ClockInIntermediaryState();
}

class _ClockInIntermediaryState extends State<ClockInIntermediary> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  bool hasError = false;
  bool isVerifying = false;
  String get appBarText =>
      widget.type == Entry.clockIn ? 'Clock In' : 'Clock Out';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarText,
          style: TextStyle(
            fontSize: 32.sp, //fontWeight: FontWeight.w700
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              Center(
                child: Image.asset(
                  'assets/logo.jpg',
                  height: 150.h,
                  //width: 600.w,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(height: 80.h),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Welcome ${widget.user.staffName}!',
                        style: textStyleSuccessScreenLarge,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Please enter your pin',
                        style: textStyleSuccessScreenSmall,
                      ),
                      SizedBox(
                        height: 70.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 500.w),
                        child: PinCodeTextField(
                          appContext: context,
                          length: 4,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          autoFocus: true,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5.r),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          controller: _pinController,
                          validator: (x) {
                            if (x!.isEmpty) {
                              return 'Please enter a valid pin';
                            }
                            return null;
                          },
                          onCompleted: (v) {
                            print("Completed");
                          },
                          onChanged: (String value) {},
                        ),
                      ),
                      SizedBox(height: 100.h),
                      !isVerifying
                          ? SizedBox(
                              height: 80.h,
                              width: 200.w,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    backgroundColor: secondaryColor,
                                    textStyle: TextStyle(
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w500)),
                                onPressed: () {
                                  bool? validationResult =
                                      _formKey.currentState?.validate();
                                  if (validationResult == true) {
                                    validateStaff();
                                  }
                                },
                                child: Text(widget.type == Entry.clockIn
                                    ? 'Clock In'
                                    : 'Clock Out'),
                              ),
                            )
                          : CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Text(
                          hasError ? "No match found" : "",
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(height: 100.h),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  validateStaff() async {
    setState(() {
      isVerifying = true;
    });
    bool check =
        await validateStaffMember(widget.user.staffId!, _pinController.text);
    if (check) {
      if (widget.type == Entry.clockIn) {
        await clockInStaff();
      } else {
        await clockOutStaff();
      }
    } else {
      setState(() {
        isVerifying = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Validation failed')));
    }
  }

  clockInStaff() async {
    DateTime now = DateTime.now();
    bool clockIn = await clockInOrOut(context, widget.user.staffId!,
        LocationsModelData.selectedLocation!.locationId!, widget.type, now);
    setState(() {
      isVerifying = false;
    });
    if (clockIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ClockInSuccess(
                  user: widget.user,
                  currentTime: now,
                )),
      );
    }
  }

  clockOutStaff() async {
    DateTime now = DateTime.now();
    dynamic clockInTime = await clockInOrOut(context, widget.user.staffId!,
        LocationsModelData.selectedLocation!.locationId!, widget.type, now);
    setState(() {
      isVerifying = false;
    });
    if (clockInTime != null && clockInTime != false) {
      DateTime clockIn = DateTime.parse(clockInTime);
      Duration sessionTime = now.difference(clockIn);
      log(printDuration(sessionTime));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ClockOutSuccess(
                  user: widget.user,
                  currentTime: now,
                  sessionTime: printDuration(sessionTime),
                )),
      );
    }
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }
}
