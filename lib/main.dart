import 'package:flutter/material.dart';
import 'package:weather_application/bloc/weather_bloc.dart';
import 'package:weather_application/constants/misc_constant.dart';
import 'package:weather_application/models/current_weather_model.dart';
import 'package:date_time_format/date_time_format.dart';
import 'api_services/api_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WeatherBloc _bloc = WeatherBloc();

  int activePage = 0;

  @override
  void initState() {
    super.initState();
    _bloc.getWeatherInfo(cityName: MiscConstant.citiesList[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
        elevation: 0,
          backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Weather-Background.png"),
            fit: BoxFit.cover
          )
        ),
        width: double.infinity,
        child: SafeArea(
          child: StreamBuilder(
              stream: _bloc.weatherInfoStream,
              builder: (context, AsyncSnapshot<APIHandler> snapshot) {
                if (snapshot.hasData) {
                  final weatherData = snapshot.data!.data as WeatherModel;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        getFormattedDate(weatherData.dt!),
                        style: textStyle(26),
                      ),
                      Text(
                        getFormattedTime(weatherData.dt! + weatherData.timezone!),
                        style: textStyle(36),
                      ),
                      Text(
                        weatherData.name!,
                        style: textStyle(26),
                      ),
                      Image.asset(
                        "assets/images-1.png",
                        color: Colors.white,
                      ),
                      Text(
                        "${weatherData.main!.temp!.round()}\u00B0 C",
                        style: textStyle(48),
                      ),
                      interactiveCitySelector(),
                      const Divider(
                        indent: 10,
                        endIndent: 10,
                        color: Colors.white,
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        color: Colors.white24,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Colors.white, width: 1.5)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              cardItem(weatherData, "Min Temp.",
                                  "${weatherData.main!.tempMin!.round()}"),
                              cardItem(weatherData, "Humidity",
                                  "${weatherData.main!.humidity}%"),
                              cardItem(weatherData, "Max Temp.",
                                  "${weatherData.main!.tempMax!.round()}"),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        indent: 10,
                        endIndent: 10,
                        color: Colors.white,
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }

  TextStyle textStyle(double size) => TextStyle(fontSize: size, color: Colors.white);

  SizedBox interactiveCitySelector() {
    return SizedBox(
      height: 100,
      width: 100,
      child: PageView.builder(
          controller: PageController(
            viewportFraction: .35,
          ),
          itemCount: MiscConstant.citiesList.length,
          onPageChanged: (val) {
            activePage = val;
            _bloc.getWeatherInfo(cityName: MiscConstant.citiesList[val]);
            setState(() {});
          },
          pageSnapping: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => Container(
                alignment: Alignment.center,
                decoration: activePage == index
                    ? const BoxDecoration(
                        border: Border(
                        top: BorderSide(color: Colors.white),
                        bottom: BorderSide(color: Colors.white),
                      ))
                    : null,
                child: Text(
                  MiscConstant.citiesList[index],
                  style: TextStyle(
                      color:
                          activePage == index ? Colors.white : Colors.white54,
                      fontWeight: activePage == index ? FontWeight.bold : null),
                ),
              )),
    );
  }

  Expanded cardItem(WeatherModel weatherData, String text, String data) {
    return Expanded(
        child: Column(
      children: [
        Text(text,
            style: const TextStyle(
                height: 1.5, color: Colors.white, fontWeight: FontWeight.bold)),
        Text(data, style: const TextStyle(height: 1.5, color: Colors.white)),
      ],
    ));
  }

  String getFormattedDate(int timeStamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return date.format('l, dS F');
  }

  String getFormattedTime(int timeStamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000,isUtc: true);
    return date.format('h:i A');
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
