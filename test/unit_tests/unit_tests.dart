import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rock_n_weather/providers/home_page_provider.dart';
import 'package:rock_n_weather/repositories/models/weather_model.dart';

import '../mocks/repositories.mocks.dart';

void main() {
  group('homePageProvider Tests', () {
    test('WeatherModel copyWith method', () {
      final weatherModel = WeatherModel(
        cityName: "city",
        countryName: "country",
        currentTemperature: 0,
      );
      final copy = weatherModel.copyWith(
        cityName: "newCity",
        countryName: "newCountry",
        currentTemperature: 1,
      );
      expect(copy.cityName, "newCity");
      expect(copy.countryName, "newCountry");
      expect(copy.currentTemperature, 1);
    });

    test('WeatherModel copyWith method with null values', () {
      final weatherModel = WeatherModel(
        cityName: "city",
        countryName: "country",
        currentTemperature: 0,
      );
      final copy = weatherModel.copyWith(
        cityName: null,
        countryName: null,
        currentTemperature: null,
      );
      expect(copy.cityName, "city");
      expect(copy.countryName, "country");
      expect(copy.currentTemperature, 0);
    });

    test('Repository tests', () async {
      MockWeatherRepositoryProtocol mockWeatherRepositoryProtocol =
          MockWeatherRepositoryProtocol();

      when(mockWeatherRepositoryProtocol.fetchCurrentWeather(
              cityName: 'Silverstone', countryName: 'UK'))
          .thenAnswer((_) async => WeatherModel(
                cityName: 'Silverstone',
                countryName: 'UK',
                currentTemperature: 0,
              ));
      final weather = await mockWeatherRepositoryProtocol.fetchCurrentWeather(
          cityName: 'Silverstone', countryName: 'UK');
      expect(weather, isA<WeatherModel>());
      expect(weather?.cityName, 'Silverstone');
      expect(weather?.countryName, 'UK');

      when(mockWeatherRepositoryProtocol.fetchForecastWeather(
              cityName: 'Silverstone', countryName: 'UK'))
          .thenAnswer((_) async => [
                WeatherModel(
                  cityName: 'Silverstone',
                  countryName: 'UK',
                  currentTemperature: 0,
                ),
              ]);

      final forecast = await mockWeatherRepositoryProtocol.fetchForecastWeather(
          cityName: 'Silverstone', countryName: 'UK');
      expect(forecast, isA<List<WeatherModel>>());
      expect(forecast?.first.cityName, 'Silverstone');
    });

    test('HomepageProvider tests', () async {
      MockWeatherRepositoryProtocol mockWeatherRepositoryProtocol =
          MockWeatherRepositoryProtocol();
      HomePageNotifier stateNotifier =
          HomePageNotifier(mockWeatherRepositoryProtocol);
      expect(stateNotifier.state.citiesWeather, null);
      expect(stateNotifier.state.homePageStatus, HomePageStatusType.loading);
      expect(stateNotifier.state.searchText, '');

      when(mockWeatherRepositoryProtocol.fetchCurrentWeather(
              cityName: 'Rio de Janeiro', countryName: 'BR'))
          .thenAnswer((_) async => WeatherModel(
                cityName: 'Rio de Janeiro',
                countryName: 'BR',
                currentTemperature: 40,
              ));

      await stateNotifier.fetchCitiesWeather(cities: [
        ("Rio de Janeiro", "BR"),
      ]);
      expect(stateNotifier.state.citiesWeather, isA<List<WeatherModel>>());
      expect(
          stateNotifier.state.citiesWeather?.first.cityName, 'Rio de Janeiro');
      expect(stateNotifier.state.citiesWeather?.first.countryName, 'BR');
      expect(stateNotifier.state.citiesWeather?.first.currentTemperature, 40);
      expect(stateNotifier.state.homePageStatus, HomePageStatusType.loaded);
    });
  });
}
