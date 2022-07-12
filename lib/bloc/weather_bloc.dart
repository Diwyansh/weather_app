import 'dart:async';

import 'package:http/http.dart';
import 'package:weather_application/api_services/api_handler.dart';
import 'package:weather_application/api_services/api_services.dart';
import 'package:weather_application/models/current_weather_model.dart';

class WeatherBloc {

  final StreamController<APIHandler> _weatherInfoController =  StreamController.broadcast();

  Sink<APIHandler> get weatherInfoSink => _weatherInfoController.sink;

  Stream<APIHandler> get weatherInfoStream => _weatherInfoController.stream;

  Future<void> getWeatherInfo({required String cityName}) async {

    APIServices apiServices = APIServices();

    Response res = await apiServices.oneCallAPI(cityName);

    if(res.statusCode == 200) {
     weatherInfoSink.add(APIHandler(status: Status.completed,isSuccess: true,data: WeatherModelFromJson(res.body)));
    } else {
      weatherInfoSink.add(APIHandler(status: Status.completed,isSuccess: false,data: WeatherModelFromJson(res.body)));
    }

  }

  dispose() {
    _weatherInfoController.close();
  }
}