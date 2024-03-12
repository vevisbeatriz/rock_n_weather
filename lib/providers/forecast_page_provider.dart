import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injector/injector.dart';
import 'package:rock_n_weather/repositories/models/weather_model.dart';
import 'package:rock_n_weather/repositories/weather_repository.dart';

/// Enum representing the possible states of the forecast page.
enum ForecastStatusType {
  loading,
  loaded,
  error,
}

/// Provider for the forecast page state.
final forecastPageProvider =
    StateNotifierProvider<ForecastPageNotifier, ForecastPageState>((ref) {
  return ForecastPageNotifier(
      Injector.appInstance.get<WeatherRepositoryProtocol>());
});

/// Notifier for the forecast page state.
class ForecastPageNotifier extends StateNotifier<ForecastPageState> {
  final WeatherRepositoryProtocol _weatherRepository;

  ForecastPageNotifier(this._weatherRepository)
      : super(ForecastPageState(
            forecast: null, forecastPageStatus: ForecastStatusType.loading));

  /// Fetches the forecast weather for a given city and country.
  ///
  /// Updates the state to loading before the request and to loaded after the request.
  /// If the forecast is null after the request, updates the state to error.
  Future<void> fetchForecastWeather(
      {required String cityName, required String countryName}) async {
    state = state.copyWith(forecastPageStatus: ForecastStatusType.loading);
    final forecast = await _weatherRepository.fetchForecastWeather(
        cityName: cityName, countryName: countryName);
    final result = forecast == null
        ? ForecastStatusType.error
        : ForecastStatusType.loaded;
    state = state.copyWith(
        forecast: forecast,
        forecastPageStatus: result);
  }
}

/// State for the forecast page.
class ForecastPageState {
  List<WeatherModel>? forecast;
  ForecastStatusType forecastPageStatus = ForecastStatusType.loading;

  ForecastPageState({required this.forecast, required this.forecastPageStatus});

  /// Returns a copy of this state with the given fields replaced with the new values.
  ForecastPageState copyWith({
    List<WeatherModel>? forecast,
    ForecastStatusType? forecastPageStatus,
  }) {
    return ForecastPageState(
      forecast: forecast ?? this.forecast,
      forecastPageStatus: forecastPageStatus ?? this.forecastPageStatus,
    );
  }
}
