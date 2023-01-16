import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tell_sam/constants/constants.dart';
import 'package:tell_sam/data/models/staff_model.dart';

class ClockInSuccess extends StatefulWidget {
  const ClockInSuccess(
      {super.key, required this.user, required this.currentTime});

  final StaffsModelData user;
  final DateTime currentTime;

  @override
  State<ClockInSuccess> createState() => _ClockInSuccessState();
}

class _ClockInSuccessState extends State<ClockInSuccess> {
  DateFormat format = DateFormat('hh:mm');
  navigateBack() async {
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;
    // Navigator.pop(context);
    Navigator.of(context)
      ..pop()
      ..pop();
  }

  @override
  void initState() {
    super.initState();
    navigateBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Clock In',
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
              'Welcome ${widget.user.staffName}!',
              style: textStyleSuccessScreenLarge,
            ),
            Text(
              'You have clocked in at ${format.format(widget.currentTime)}',
              style: textStyleSuccessScreenSmall,
            )
          ],
        ));
  }
}
