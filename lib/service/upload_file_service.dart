import 'package:dio/dio.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_kickstart/model/file_model.dart';

var appConfig = Config.fromJson(config);

Future<FileResponse> uploadFileService(FormData formData) async {

    var response = await Dio()
        .post("${appConfig.baseUrl}/api/chat/upload", data: formData);
    print(response.data);
    var json = response.data;
    FileResponse fileResponse = FileResponse.fromJson(json);

    if (fileResponse.message == "success") {
      return fileResponse;
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception("${response.statusCode}");
    }
}
