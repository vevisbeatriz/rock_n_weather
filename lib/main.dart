import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injector/injector.dart';
import 'package:rock_n_weather/providers/forecast_page_provider.dart';
import 'package:rock_n_weather/repositories/weather_repository.dart';
import 'package:rock_n_weather/screens/forecast_page.dart';
import 'package:rock_n_weather/screens/home_page.dart';
import 'package:rock_n_weather/utilities/constants.dart';

/// The main function of the application.
///
/// This function initializes the Injector for dependency injection and
/// starts the application with the ProviderScope widget.
void main() {
  // Get the instance of the Injector.
  final injector = Injector.appInstance;

  // Register the WeatherRepositoryProtocol dependency.
  injector
      .registerDependency<WeatherRepositoryProtocol>(() => WeatherRepository());

  // Start the application with the ProviderScope widget.
  runApp(const ProviderScope(child: MyApp()));
}

/// The MyApp widget.
///
/// This widget is the root of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock n Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.clearSky,
      ),
      home: const HomePage(),
    );
  }
}
