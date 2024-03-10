import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injector/injector.dart';
import 'package:rock_n_weather/repositories/models/weather_model.dart';
import 'package:rock_n_weather/repositories/weather_repository.dart';

enum HomePageStatusType {
  loading,
  loaded,
  error,
}

final homePageProvider =
    StateNotifierProvider<HomePageNotifier, HomePageState>((ref) {
  return HomePageNotifier(
      Injector.appInstance.get<WeatherRepositoryProtocol>());
});

class HomePageNotifier extends StateNotifier<HomePageState> {
  final WeatherRepositoryProtocol _weatherRepository;

  HomePageNotifier(this._weatherRepository)
      : super(HomePageState(citiesWeather: null, homePageStatus: HomePageStatusType.loading));

  void fetchCitiesWeather({required List<(String cityName, String countryName)> cities}) async {
    List<WeatherModel>? citiesWeather = [];
    state = state.copyWith(homePageStatus: HomePageStatusType.loading);
    for (final city in cities) {
      final weather = await _weatherRepository.fetchCurrentWeather(
          cityName: city.$1, countryName: city.$2);
      if (weather != null) {
        citiesWeather.add(weather);
      }
    }
    state = state.copyWith(weather: citiesWeather, homePageStatus: citiesWeather.isEmpty ? HomePageStatusType.error : HomePageStatusType.loaded);
  }
}

class HomePageState {
  List<WeatherModel>? citiesWeather;
  HomePageStatusType homePageStatus = HomePageStatusType.loading;

  HomePageState({required this.citiesWeather, required this.homePageStatus});

  HomePageState copyWith({
    List<WeatherModel>? weather,
    HomePageStatusType? homePageStatus,
  }) {
    return HomePageState(
      citiesWeather: weather ?? citiesWeather,
      homePageStatus: homePageStatus ?? this.homePageStatus,
    );
  }
}