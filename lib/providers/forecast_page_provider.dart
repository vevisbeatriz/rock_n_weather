import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injector/injector.dart';
import 'package:rock_n_weather/repositories/models/weather_model.dart';
import 'package:rock_n_weather/repositories/weather_repository.dart';

enum ForecastStatusType {
  loading,
  loaded,
  error,
}

final forecastPageProvider =
    StateNotifierProvider<ForecastPageNotifier, ForecastPageState>((ref) {
  return ForecastPageNotifier(
      Injector.appInstance.get<WeatherRepositoryProtocol>());
});

class ForecastPageNotifier extends StateNotifier<ForecastPageState> {
  final WeatherRepositoryProtocol _weatherRepository;

  ForecastPageNotifier(this._weatherRepository)
      : super(ForecastPageState(forecast: null, forecastPageStatus: ForecastStatusType.loading));

  void fetchForecastWeather(
      {required String cityName, required String countryName}) async {
    state = state.copyWith(forecast: null, forecastPageStatus: ForecastStatusType.loading);
    final forecast = await _weatherRepository.fetchForecastWeather(
        cityName: cityName, countryName: countryName);
    state = state.copyWith(forecast: forecast, forecastPageStatus: forecast == null ? ForecastStatusType.error : ForecastStatusType.loaded);
  }
}

class ForecastPageState {
  List<WeatherModel>? forecast;
  ForecastStatusType forecastPageStatus = ForecastStatusType.loading;

  ForecastPageState({required this.forecast, required this.forecastPageStatus});

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