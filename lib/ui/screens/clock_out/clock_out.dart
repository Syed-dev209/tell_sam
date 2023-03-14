import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tell_sam/data/util.dart';
import 'package:tell_sam/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tell_sam/ui/screens/clock_in/clock_in_success.dart';
import 'package:tell_sam/ui/screens/clock_out/clock_out_intermediary.dart';
import 'package:tell_sam/ui/screens/clock_out/clock_out_success.dart';

class ClockOut extends StatefulWidget {
  const ClockOut({super.key});

  @override
  State<ClockOut> createState() => _ClockOutState();
}

class _ClockOutState extends State<ClockOut> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    //_pinController.dispose();
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
              SizedBox(height: 100.h),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 500.w),
                        child: SearchField(
                           suggestionDirection: SuggestionDirection.up,
                          controller: _nameController,
                          autoCorrect: false,
                          suggestions: usersData
                              .map((e) => SearchFieldListItem(e.name))
                              .toList(),
                          onSuggestionTap: (value) {
                            FocusScope.of(context).unfocus();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClockOutIntermediary(
                                        username: value.searchKey,
                                      )),
                            );
                          },
                          suggestionState: Suggestion.expand,
                          textInputAction: TextInputAction.next,
                          hint: 'Please enter your name',
                          hasOverlay: true,
                          searchStyle: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.black.withOpacity(0.8),
                          ),
                          validator: (x) {
                            if (!usersData.any((item) => item.name == x) ||
                                x!.isEmpty) {
                              return 'Please enter a valid name';
                            }
                            return null;
                          },
                          searchInputDecoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                          maxSuggestionsInViewPort: 6,
                          itemHeight: 50,
                        ),
                      ),
                      SizedBox(height: 500.h),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
