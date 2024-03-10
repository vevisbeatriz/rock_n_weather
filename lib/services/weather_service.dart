import 'package:dio/dio.dart';
import 'package:rock_n_weather/services/models/current_weather_model.dart';
import 'package:rock_n_weather/services/models/forecast_weather_model.dart';

// API key for OpenWeatherMap
const apiKey = '40cfe72eb26fa8c49c9fbb1c28d87d81';

// Creating an instance of Dio for making HTTP requests
final dio = Dio();

// WeatherService class that contains methods to fetch weather data
class WeatherService {
  // Method to fetch current weather data
  static Future<CurrentWeatherModel?> getWeatherData(
      {required String cityName, required String countryName}) async {
    Response response;
    try {
      // Making a GET request to the OpenWeatherMap API's weather endpoint
      response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': '$cityName,$countryName',
          'appid': apiKey,
          'units': 'metric',
        },
      );
      // If the request is successful, create a CurrentWeatherModel object from the response data and return it
      if (response.statusCode == 200) {
        return CurrentWeatherModel.fromJson(response.data);
      }
    } catch (e) {
      // If the request fails, print the error
      print(e);
    }
    // If the request fails, return null
    return null;
  }

  // Method to fetch forecast weather data
  static Future<ForecastWeatherModel?> getForecastData(
      {required String cityName, required String countryName}) async {
    Response response;
    try {
      // Making a GET request to the OpenWeatherMap API's forecast endpoint
      response = await dio.get(
        'https://api.openweathermap.org/data/2.5/forecast',
        queryParameters: {
          'q': '$cityName,$countryName',
          'appid': apiKey,
          'units': 'metric',
        },
      );
      // If the request is successful, create a ForecastWeatherModel object from the response data and return it
      if (response.statusCode == 200) {
        return ForecastWeatherModel.fromJson(response.data);
      }
    } catch (e) {
      // If the request fails, print the error
      print(e);
    }
    // If the request fails, return null
    return null;
  }
}