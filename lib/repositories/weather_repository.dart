import 'package:rock_n_weather/repositories/models/weather_model.dart';
import 'package:rock_n_weather/services/weather_service.dart';

abstract class WeatherRepositoryProtocol {
  // Define a method to fetch the current weather for a given city and country
  Future<WeatherModel?> fetchCurrentWeather({required String cityName, required String countryName});
  Future<List<WeatherModel>?> fetchForecastWeather({required String cityName, required String countryName});
}

class WeatherRepository implements WeatherRepositoryProtocol {
  @override
  Future<WeatherModel?> fetchCurrentWeather(
      {required String cityName, required String countryName}) async {
    // Fetch the weather data from the WeatherService
    final currentWeatherModel = await WeatherService.getWeatherData(cityName: cityName, countryName: countryName);
    // If the fetched data is not null and contains the necessary information, create a CityWeatherModel
    if (currentWeatherModel != null && currentWeatherModel.name != null && currentWeatherModel.main?.temp != null) {
      return WeatherModel(
        cityName: currentWeatherModel.name!,
        currentTemperature: currentWeatherModel.main!.temp!,
        minTemperature: currentWeatherModel.main?.tempMin,
        maxTemperature: currentWeatherModel.main?.tempMax,
        description: currentWeatherModel.weather?.first.description,
        icon: currentWeatherModel.weather?.first.icon,
        date: DateTime.now(),
      );
    }
    // If the fetched data is null or does not contain the necessary information, return null
    return null;
  }

  @override
  Future<List<WeatherModel>?> fetchForecastWeather(
      {required String cityName, required String countryName}) async {
    // Fetch the weather data from the WeatherService
    final forecastWeatherModel = await WeatherService.getForecastData(cityName: cityName, countryName: countryName);
    // If the fetched data is not null and contains the necessary information, create a CityWeatherModel
    if (forecastWeatherModel != null && forecastWeatherModel.list != null) {
      List<WeatherModel>? forecast = [];
      for (var i = 0; i < forecastWeatherModel.list!.length; i++) {
        forecast.add(WeatherModel(
          cityName: cityName,
          currentTemperature: forecastWeatherModel.list![i].main!.temp!,
          description: forecastWeatherModel.list![i].weather?.first.main,
          icon: forecastWeatherModel.list![i].weather?.first.icon,
          date: DateTime.fromMicrosecondsSinceEpoch(forecastWeatherModel.list![i].dt ?? 0),
        ));
      }
      return forecast;
    }
    // If the fetched data is null or does not contain the necessary information, return null
    return null;
  }
}