import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tell_sam/constants/network_constant.dart';
import 'package:tell_sam/data/dio_service.dart';
import 'package:tell_sam/data/models/location_model.dart';
import 'package:tell_sam/data/models/staff_model.dart';
import 'package:tell_sam/data/storage_service.dart';
import 'package:tell_sam/ui/screens/clock_in/clock_in.dart';

var dio = DioService.dio;

Future<LocationsModel?> getAllLocations() async {
  try {
    var response = await dio.get(APIS.allLocation);
    log(response.data.toString());
    if (response.statusCode == 200) {
      return LocationsModel.fromJson(response.data);
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.toString());
    return null;
  }
}

Future<StaffsModel?> getAllStaffMembers() async {
  try {
    var response = await dio.get(APIS.allStaff);
    log(response.data.toString());
    if (response.statusCode == 200) {
      return StaffsModel.fromJson(response.data);
    } else {
      return null;
    }
  } on DioError catch (e) {
    log(e.toString());
    return null;
  }
}

Future<bool> validateStaffMember(int staffId, String pin) async {
  try {
    Map<String, dynamic> data = {"staff_id": staffId, "pin": pin};
    var response = await dio.post(APIS.validateStaff, data: data);
    log(response.data.toString());
    if (response.statusCode == 200) {
      return response.data['status'] == 1;
    } else {
      return false;
    }
  } on DioError catch (e) {
    log(e.toString());
    return false;
  }
}

Future clockInOrOut(
    context, int staffId, int locationId, Entry type, DateTime current) async {
  try {
    Map<String, dynamic> data = {
      "staff_id": staffId,
      "location_id": locationId,
      "type": type == Entry.clockIn ? 'clockin' : 'clockout',
      "timestamp": current.toString()
    };
    log(data.toString());

    var response = await dio.post(APIS.clock, data: data);
    log(response.data.toString());
    if (response.statusCode == 200) {
      if (type == Entry.clockOut) {
        if (response.data['status'] == 1) {
          return response.data['clockin_record']['record_timestamp'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${response.data['message']}')));
          return null;
        }
      } else {
        // return response.data['status'] == 1;
        if (response.data['status'] == 1) {
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${response.data['message']}')));
          return false;
        }
      }
    } else {
      return false;
    }
  } on DioError catch (e) {
    log(e.toString());
    return false;
  }
}
