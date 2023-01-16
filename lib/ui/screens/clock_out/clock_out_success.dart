import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tell_sam/constants/constants.dart';
import 'package:tell_sam/data/models/staff_model.dart';

class ClockOutSuccess extends StatefulWidget {
  const ClockOutSuccess(
      {super.key,
      required this.currentTime,
      required this.user,
      required this.sessionTime});

  final StaffsModelData user;
  final DateTime currentTime;
  final String sessionTime;

  @override
  State<ClockOutSuccess> createState() => _ClockOutSuccessState();
}

class _ClockOutSuccessState extends State<ClockOutSuccess> {
  DateFormat format = DateFormat('hh:mm');
  navigateBack() async {
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;
    Navigator.of(context)
      ..pop()
      ..pop();
  }

  @override
  void initState() {
    super.initState();
    navigateBack();
    //pop after 5 seconds
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Clock Out',
            style: TextStyle(
              fontSize: 32.sp, //fontWeight: FontWeight.w700
            ),
          ),
          backgroundColor: primaryColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.jpg',
                height: 150.h,
                //width: 600.w,
                fit: BoxFit.fitHeight,
              ),
            ),
            Text(
              'Goodbye ${widget.user.staffName}!',
              style: textStyleSuccessScreenLarge,
            ),
            Text(
              'You have clocked out at ${format.format(widget.currentTime)}',
              style: textStyleSuccessScreenSmall,
            ),
            Text(
              'You have worked for ${widget.sessionTime}',
              style: textStyleSuccessScreenSmall,
            ),
          ],
        ));
  }
}
