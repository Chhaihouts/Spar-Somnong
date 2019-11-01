import 'package:dio/dio.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/user.dart';

var appConfig = Config.fromJson(config);

Future<UserResponse> getUser(FormData formData) async {
  try {
    var response = await Dio()
        .post("${appConfig.baseUrl}/api/auth/signup", data: formData);
    print(response.data);
    var json = response.data;
    UserResponse userResponse = UserResponse.fromJson(json);

    if (userResponse.message == "success") {
      return userResponse;
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception("${response.statusCode}");
    }
  } catch (error) {
    print("response err $error");
    throw Exception("Error code $error");
  }
}
