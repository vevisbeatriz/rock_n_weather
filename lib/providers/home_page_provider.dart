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
      : super(HomePageState(citiesWeather: null, homePageStatus: HomePageStatusType.loading, originalCitiesWeather: null, searchText: ""));

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
    state = state.copyWith(citiesWeather: citiesWeather, homePageStatus: citiesWeather.isEmpty ? HomePageStatusType.error : HomePageStatusType.loaded, originalCitiesWeather: citiesWeather);
  }

 void filterCitiesWeather({required String filter}) {
    if (filter.isEmpty) {
      state = state.copyWith(citiesWeather: state.originalCitiesWeather, searchText: filter);
    } else {
      final filteredCitiesWeather = state.originalCitiesWeather?.where((element) => element.cityName.toLowerCase().contains(filter.toLowerCase())).toList();
      state = state.copyWith(citiesWeather: filteredCitiesWeather, searchText: filter);
    }
  }
}

class HomePageState {
  List<WeatherModel>? citiesWeather;
  HomePageStatusType homePageStatus = HomePageStatusType.loading;
  List<WeatherModel>? originalCitiesWeather;
  String searchText;

  HomePageState({required this.citiesWeather, required this.homePageStatus, required this.originalCitiesWeather, required this.searchText});

  HomePageState copyWith({
    List<WeatherModel>? citiesWeather,
    HomePageStatusType? homePageStatus,
    List<WeatherModel>? originalCitiesWeather,
    String? searchText,
  }) {
    return HomePageState(
      citiesWeather: citiesWeather ?? citiesWeather,
      homePageStatus: homePageStatus ?? this.homePageStatus,
      originalCitiesWeather: originalCitiesWeather ?? this.originalCitiesWeather,
      searchText: searchText ?? this.searchText,
    );
  }
}