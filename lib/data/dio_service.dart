import 'package:dio/dio.dart';
import 'package:tell_sam/constants/network_constant.dart';

class DioService {
  static DioService _dioService = DioService._internal();

  factory DioService() {
    return _dioService;
  }
  DioService._internal();

  static Dio dio = Dio(BaseOptions(baseUrl: APIS.baseUrl,
  headers: {
    "x-access-token": APIS.apiAccessKey,
  }));
}
