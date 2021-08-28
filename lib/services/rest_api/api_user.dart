import 'package:dio/dio.dart';

import 'api.dart';

class ApiUser extends Api {
  /// Login
  Future<Response<Map<String, dynamic>>> logIn(String employeeId, String password) async {
    final Options options = await getOptions();
    return wrapE(() => dio.post<Map<String, dynamic>>('$apiBaseUrl/users/login', options: options, data: <String, String>{
          'employee_id': employeeId,
          'password': password,
        }));
  }

  /// Login With Error
  Future<Response<Map<String, dynamic>>> logInWithError() async {
    final Options options = await getOptions();
    return wrapE(() => dio.post<Map<String, dynamic>>('$apiBaseUrl/login-err', options: options, data: <String, String>{
          'email': 'email',
          'password': 'password',
        }));
  }
}
