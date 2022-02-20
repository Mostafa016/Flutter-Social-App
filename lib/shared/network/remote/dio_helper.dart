import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> postNotification({
    String path = 'fcm/send',
    required Map<String, dynamic> notificationData,
  }) async {
    return await dio.post(
      path,
      data: notificationData,
    );
  }
}
