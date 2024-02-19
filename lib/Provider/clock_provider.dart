import 'dart:async';

import 'package:flutter/foundation.dart';

class ClockProvider with ChangeNotifier {
  DateTime _currentTime = DateTime.now();

  DateTime get currentTime => _currentTime;
  ClockProvider() {
    Timer.periodic(Duration(seconds: 60), (timer) {
      _updateTime();
    });
  }
  void _updateTime() {
    _currentTime = DateTime.now();
    notifyListeners();
  }
}
//
// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
//
// class ClockProvider with ChangeNotifier {
//   DateTime _currentTime = DateTime.now();
//
//   DateTime get currentTime => _currentTime;
//
//   final String timezoneDbApiKey = "OAN7X6CT7M74";
//
//   ClockProvider() {
//     Timer.periodic(Duration(seconds: 60), (timer) {
//       _updateTime();
//     });
//   }
//
//   Future<String> _getTimeZone(String city) async {
//     final response = await http.get(
//       Uri.parse('http://api.timezonedb.com/v2.1/get-time-zone'),
//       // Include your API key and adjust parameters accordingly
//       // For example, you might want to use 'city' or 'lat', 'lng' parameters
//       // to specify the location for which you want the time zone.
//       // Check TimezoneDb API documentation for details.
//       // Example parameters: {'key': timezoneDbApiKey, 'format': 'json', 'by': 'city', 'city': city}
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['zoneName'];
//     } else {
//       throw Exception('Failed to load time zone');
//     }
//   }
//
//   void _updateTime() async {
//     try {
//       final timeZone = await _getTimeZone("YOUR_CITY_NAME");
//       final now = DateTime.now().toUtc();
//       final locationTime = now.add(Duration(hours: now.isUtc ? 0 : 1)); // Adjust to local time
//
//       _currentTime = locationTime;
//       notifyListeners();
//     } catch (error) {
//       print("Error updating time: $error");
//     }
//   }
// }
