import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tell_sam/constants/constants.dart';
import 'package:tell_sam/data/models/location_model.dart';
import 'package:tell_sam/ui/screens/clock_in/clock_in.dart';
import 'package:tell_sam/ui/screens/clock_out/clock_out.dart';

class HomePage extends StatefulWidget {
  final LocationsModelData selectedLocation;
  const HomePage({super.key, required this.selectedLocation});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime currentTime;

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
  }

  updateTime() {
    currentTime = currentTime.add(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Center(
                  child: Text(
                    DateFormat('EEEE d MMMM y').format(DateTime.now()),
                    style: textStyleSuccessScreenSmall,
                  ),
                );
              },
            ),
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
            StreamBuilder<int>(
              stream: Stream.periodic(const Duration(seconds: 1),
                  (computationCount) => computationCount),
              builder: (context, snapshot) {
                updateTime();
                return Center(
                  child: Text(DateFormat('HH:mm').format(currentTime),
                      style: textStyleSuccessScreenXLarge),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 80.h,
                      width: 200.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            backgroundColor: secondaryColor,
                            textStyle: TextStyle(
                                fontSize: 28.sp, fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ClockInAndClockOut(type: Entry.clockIn,)),
                          );
                        },
                        child: const Text('Clock In'),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 80.h,
                      width: 200.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            backgroundColor: secondaryColor,
                            textStyle: TextStyle(
                                fontSize: 28.sp, fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ClockInAndClockOut(type: Entry.clockOut)),
                          );
                        },
                        child: const Text('Clock Out'),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
