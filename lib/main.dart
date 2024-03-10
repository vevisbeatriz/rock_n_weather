import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injector/injector.dart';
import 'package:rock_n_weather/providers/forecast_page_provider.dart';
import 'package:rock_n_weather/repositories/weather_repository.dart';
import 'package:rock_n_weather/screens/forecast_page.dart';
import 'package:rock_n_weather/screens/home_page.dart';
import 'package:rock_n_weather/utilities/constants.dart';

void main() {
  final injector = Injector.appInstance;
  injector
      .registerDependency<WeatherRepositoryProtocol>(() => WeatherRepository());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.clearSky,
      ),
      home: const HomePage(),
    );
  }
}