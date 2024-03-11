import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injector/injector.dart';
import 'package:rock_n_weather/repositories/models/weather_model.dart';
import 'package:rock_n_weather/repositories/weather_repository.dart';

/// Enum representing the possible states of the home page.
enum HomePageStatusType {
  loading,
  loaded,
  error,
}

/// Provider for the home page state.
final homePageProvider =
    StateNotifierProvider<HomePageNotifier, HomePageState>((ref) {
  return HomePageNotifier(
      Injector.appInstance.get<WeatherRepositoryProtocol>());
});

/// Notifier for the home page state.
class HomePageNotifier extends StateNotifier<HomePageState> {
  final WeatherRepositoryProtocol _weatherRepository;

  HomePageNotifier(this._weatherRepository)
      : super(HomePageState(
            citiesWeather: null,
            homePageStatus: HomePageStatusType.loading,
            originalCitiesWeather: null,
            searchText: ""));

  /// Fetches the current weather for a list of cities.
  ///
  /// Updates the state to loading before the request and to loaded after the request.
  /// If the citiesWeather is empty after the request, updates the state to error.
  void fetchCitiesWeather(
      {required List<(String cityName, String countryName)> cities}) async {
    List<WeatherModel>? citiesWeather = [];
    state = state.copyWith(homePageStatus: HomePageStatusType.loading);
    for (final city in cities) {
      final weather = await _weatherRepository.fetchCurrentWeather(
          cityName: city.$1, countryName: city.$2);
      if (weather != null) {
        citiesWeather.add(weather);
      }
    }
    state = state.copyWith(
        citiesWeather: citiesWeather,
        homePageStatus: citiesWeather.isEmpty
            ? HomePageStatusType.error
            : HomePageStatusType.loaded,
        originalCitiesWeather: citiesWeather);
  }

  /// Filters the citiesWeather list based on a filter string (for the Search Bar)
  ///
  /// If the filter string is empty, resets the citiesWeather to the original list.
  /// Otherwise, updates the citiesWeather to a filtered list.
  void filterCitiesWeather({required String filter}) {
    if (filter.isEmpty) {
      state = state.copyWith(
          citiesWeather: state.originalCitiesWeather, searchText: filter);
    } else {
      final filteredCitiesWeather = state.originalCitiesWeather
          ?.where((element) =>
              element.cityName.toLowerCase().contains(filter.toLowerCase()))
          .toList();
      state = state.copyWith(
          citiesWeather: filteredCitiesWeather, searchText: filter);
    }
  }
}

/// State for the home page.
class HomePageState {
  List<WeatherModel>? citiesWeather;
  HomePageStatusType homePageStatus = HomePageStatusType.loading;
  List<WeatherModel>? originalCitiesWeather;
  String searchText;

  HomePageState(
      {required this.citiesWeather,
      required this.homePageStatus,
      required this.originalCitiesWeather,
      required this.searchText});

  /// Returns a copy of this state with the given fields replaced with the new values.
  HomePageState copyWith({
    List<WeatherModel>? citiesWeather,
    HomePageStatusType? homePageStatus,
    List<WeatherModel>? originalCitiesWeather,
    String? searchText,
  }) {
    return HomePageState(
      citiesWeather: citiesWeather ?? citiesWeather,
      homePageStatus: homePageStatus ?? this.homePageStatus,
      originalCitiesWeather:
          originalCitiesWeather ?? this.originalCitiesWeather,
      searchText: searchText ?? this.searchText,
    );
  }
}
