import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tell_sam/data/util.dart';
import 'package:tell_sam/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tell_sam/ui/screens/clock_in/clock_in_success.dart';
import 'package:tell_sam/ui/screens/clock_out/clock_out_success.dart';

class ClockOutIntermediary extends StatefulWidget {
  final String username;
  const ClockOutIntermediary({required this.username, super.key});

  @override
  State<ClockOutIntermediary> createState() => _ClockOutIntermediaryState();
}

class _ClockOutIntermediaryState extends State<ClockOutIntermediary> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  bool hasError = false;
  bool sessionInProgressError = false;

  @override
  void dispose() {
    super.dispose();
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
                        'Hi ${widget.username}!',
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
                          obscureText: true, keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          autoFocus: true,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5.r),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                          ),
                          animationDuration: const Duration(milliseconds: 300),

                          enableActiveFill: true,
                          //errorAnimationController: errorController,
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
                          onChanged: (value) {
                            print(value);
                            print(_pinController.text);
                            // setState(() {
                            //   currentText = value;
                            // });
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return false;
                          },
                        ),
                      ),
                      SizedBox(height: 100.h),
                      SizedBox(
                        height: 80.h,
                        width: 200.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              primary: secondaryColor,
                              textStyle: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w500)),
                          onPressed: () {
                            bool? validationResult =
                                _formKey.currentState?.validate();

                            if (validationResult == true) {
                              int? validatedUserIndex = matchUser();
                              if (validatedUserIndex != null &&
                                  usersData[validatedUserIndex]
                                      .sessionStarted) {
                                setState(() {
                                  sessionInProgressError = false;
                                });
                                //
                                //
                                DateTime currentTime = DateTime.now();

                                usersData[validatedUserIndex].sessionEndTime =
                                    currentTime;
                                usersData[validatedUserIndex].sessionStarted =
                                    false;

                                String formattedTime =
                                    DateFormat.jm().format(currentTime);
                                Duration difference = currentTime.difference(
                                    usersData[validatedUserIndex]
                                        .sessionStartTime!);

                                String sessionDays = (difference.inDays == 0)
                                    ? ''
                                    : '${difference.inDays} day(s)';
                                String sessionHours = (difference.inHours == 0)
                                    ? ''
                                    : (sessionDays != '')
                                        ? ' and ${difference.inHours % 24} hour(s)'
                                        : '${difference.inHours % 24} hour(s)';
                                String sessionMinutes = (difference.inMinutes ==
                                        0)
                                    ? ''
                                    : (sessionHours != '' || sessionDays != '')
                                        ? ' and ${difference.inMinutes % 60} minute(s)'
                                        : '${difference.inMinutes % 60} minute(s)';
                                String sessionTime =
                                    sessionDays + sessionHours + sessionMinutes;

                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => ClockOutSuccess(
                                //             userName:
                                //                 usersData[validatedUserIndex]
                                //                     .name,
                                //             currentTime: formattedTime,
                                //             sessionTime: sessionTime,
                                //           )),
                                // );
                              }
                              setState(() {
                                sessionInProgressError = true;
                              });
                            }
                          },
                          child: const Text('Clock Out'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Text(
                          hasError
                              ? "No match found"
                              : (sessionInProgressError)
                                  ? "No session in progress"
                                  : "",
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

  int? matchUser() {
    for (int i = 0; i < usersData.length; i++) {
      if (usersData[i].name == widget.username &&
          usersData[i].pin == _pinController.text) {
        setState(() {
          hasError = false;
        });

        return i;
      }
    }

    setState(() {
      hasError = true;
    });
    return null;
  }
}
