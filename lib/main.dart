import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Pages/MyHomePage.dart';
import 'package:weather_app/Pages/WeatherPage.dart';
import 'package:weather_app/Provider/clock_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClockProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weateher App',
        theme: ThemeData(primarySwatch: Colors.purple),
        home: WeatherPage(),
      ),
    );
  }
}
