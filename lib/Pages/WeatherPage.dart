import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/Provider/clock_provider.dart';
import 'package:weather_app/consts.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  var searchText = TextEditingController();
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  void _fetchWeatherData(String city) {
    _wf.currentWeatherByCityName(city).then((value) {
      setState(() {
        _weather = value;
        _saveLocationToSharedPreferences(city);
      });
    });
  }

  void _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLocation = prefs.getString('savedLocation');

    if (savedLocation == null || savedLocation.isEmpty) {
      // Set a default city (e.g., "London") if no saved location is found
      savedLocation = "London";
    }

    _fetchWeatherData(savedLocation);
  }

  void _saveLocationToSharedPreferences(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('savedLocation', location);
  }

  @override
  Widget build(BuildContext context) {
    final clockProvider = Provider.of<ClockProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffc9688a), Color(0xffa1c4fd)],
            begin: FractionalOffset(0.0, 1.0),
            end: FractionalOffset(1.0, 0.0),
          ),
        ),
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            //  mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.1,
              ),
              _searchLocation(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.01,
              ),
              _locationHeader(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.01,
              ),
              _dateTimeInfo(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              _weatherIcon(),
              // SizedBox(
              //   height: MediaQuery.sizeOf(context).height * 0.02,
              // ),
              _currentTemperature(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              _otherInformation(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _searchLocation() {
  //   return Container(
  //     width: 200,
  //     child: (TextField(
  //         controller: searchText,
  //         decoration: InputDecoration(
  //             label: Text("Enter Your Location!!"),
  //             prefixIcon: Icon(Icons.location_city)))),
  //   );
  // }

  Widget _searchLocation() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        child: TextField(
          controller: searchText,
          onSubmitted: (value) {
            _fetchWeatherData(value);
          },
          decoration: InputDecoration(
            labelText: "Search City!!",
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: BorderSide(color: Colors.purple, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: BorderSide(color: Colors.grey, width: 2)),
            prefixIcon: Icon(Icons.search),
          ),
          // keyboardType: TextInputType.text,
        ),
      ),
    );
  }

  Widget _locationHeader() {
    return (Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
      ),
    ));
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    DateTime currentDateTime = DateTime.now();
    String timeOfDay = '';
    if (currentDateTime.hour < 12) {
      timeOfDay = 'Morning';
    } else if (currentDateTime.hour < 17) {
      timeOfDay = 'Afternoon';
    } else if (currentDateTime.hour < 21) {
      timeOfDay = 'Evening';
    } else {
      timeOfDay = 'Night';
    }

    // DateTime now = _weather!.date!;
    return Column(
      children: [
        Consumer<ClockProvider>(
          builder: (context, timeModel, child) {
            return Text(
              '${DateFormat("h:mm:s a").format(timeModel.currentTime)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            );
          },
        ),
        const SizedBox(
          height: 11,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "  ${DateFormat("d.MM.y").format(now)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        Text(
          timeOfDay,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"))),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _currentTemperature() {
    return Text(
      "${_weather?.temperature!.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
          color: Colors.black, fontSize: 70, fontWeight: FontWeight.w500),
    );
  }

  Widget _otherInformation() {
    return (Container(
      width: MediaQuery.sizeOf(context).width * 0.80,
      height: MediaQuery.sizeOf(context).height * 0.12,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 222, 47, 70),
              Color.fromARGB(255, 37, 115, 211)
            ],
            begin: FractionalOffset(1.0, 0.5),
            end: FractionalOffset(0.0, 1.0),
            // stops: [0.0, 1.0]
          )),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              // Icon(Icons.wind_power)
            ],
          )
        ],
      ),
    ));
  }
}
