/// Define a class to model the weather in a city
class WeatherModel {
  final String cityName; // Name of the city
  final String countryName; // Name of the country
  final double currentTemperature; // Temperature in the city
  final double? minTemperature; // Minimum temperature in the city
  final double? maxTemperature; // Maximum temperature in the city
  final String? description; // Description of the weather
  final String? icon; // Icon representing the weather
  final DateTime? date; // Date of the weather report

  WeatherModel({
    required this.cityName,
    required this.countryName,
    required this.currentTemperature,
    this.minTemperature,
    this.maxTemperature,
    this.description,
    this.icon,
    this.date,
  });

  /// Define a method to create a copy of the CityWeatherModel with some properties possibly changed
  copyWith({
    String? cityName,
    String? countryName,
    double? currentTemperature,
    double? minTemperature,
    double? maxTemperature,
    String? description,
    String? icon,
    DateTime? date,
  }) {
    return WeatherModel(
      cityName: cityName ?? this.cityName,
countryName: countryName ?? this.countryName,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      date: date ?? this.date,
    );
  }
}
