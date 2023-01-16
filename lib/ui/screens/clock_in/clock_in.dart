import 'dart:async';

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tell_sam/controllers/base_service.dart';
import 'package:tell_sam/data/models/staff_model.dart';
import 'package:tell_sam/data/util.dart';
import 'package:tell_sam/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tell_sam/ui/screens/clock_in/clock_in_intermediate.dart';

enum Entry { clockIn, clockOut }

class ClockInAndClockOut extends StatefulWidget {
  final Entry type;

  const ClockInAndClockOut({super.key, required this.type});

  @override
  State<ClockInAndClockOut> createState() => _ClockInAndClockOutState();
}

class _ClockInAndClockOutState extends State<ClockInAndClockOut> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  late StreamController<StaffsModel?> staffsStream;
  StaffsModelData? selectedMember;

  getStaff() {
    getAllStaffMembers().then((value) {
      staffsStream.add(value);
      return value;
    });
  }

  String get appBarText => widget.type == Entry.clockIn ? 'Clock In' : 'Clock Out';

  @override
  void initState() {
    super.initState();
    staffsStream = StreamController<StaffsModel?>();
    getStaff();
  }

  @override
  void dispose() {
    _nameController.dispose();
    staffsStream.close();
    super.dispose();
  }

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
              SizedBox(height: 100.h),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      StreamBuilder<StaffsModel?>(
                          stream: staffsStream.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasError ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.data == null) {
                              return Center(
                                child: Text('No staff members found'),
                              );
                            }
                            StaffsModel staffsModel = snapshot.data!;
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 400.w),
                              child: SearchField<StaffsModelData>(
                                controller: _nameController,
                                autoCorrect: false,
                                suggestions: staffsModel.data!
                                    .map((e) =>
                                        SearchFieldListItem<StaffsModelData>(
                                            e?.staffName ?? 'N/A',
                                            item: e))
                                    .toList(),
                                onSuggestionTap: (value) {
                                  FocusScope.of(context).unfocus();
                                  selectedMember = value.item;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ClockInIntermediary(
                                              user: selectedMember!,
                                              type: widget.type,
                                            )),
                                  );
                                },
                                suggestionState: Suggestion.expand,
                                textInputAction: TextInputAction.next,
                                hint: 'Please enter your name',
                                hasOverlay: false,
                                searchStyle: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                validator: (x) {
                                  if (!staffsModel.data!.any(
                                          (item) => item!.staffName == x) ||
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
                            );
                          }),
                      SizedBox(height: 100.h),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
