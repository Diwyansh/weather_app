import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weather_application/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class APIServices {
  Future<http.Response> oneCallAPI(String cityName) async {
    try {
      String extUrl =
          "q=$cityName&units=metric&appid=${APIConstants.apiKey}";

      Uri uri = Uri.parse(APIConstants.baseUrl + extUrl);

      http.Response res = await http.get(uri);

      return res;

    } on SocketException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } on Exception catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
