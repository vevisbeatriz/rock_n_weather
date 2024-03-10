import 'package:flutter/material.dart';
import 'package:rock_n_weather/utilities/constants.dart';
import 'package:rock_n_weather/repositories/models/weather_model.dart';

// This is a stateless widget that represents a weather card.
class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.weather});

  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Text(
            weather.cityName.toUpperCase() ?? "",
            style: titleStyle,
          ),
          // The weather icon and temperature are displayed in a Row widget.
          Row(
            children: [
              // The weather icon is displayed in an Image widget.
              Expanded(
                flex: 3,
                child: Image.network(
                  "http://openweathermap.org/img/wn/${weather.icon}@4x.png",
                  height: 140,
                ),
              ),
              // The temperature and description are displayed in a Column widget.
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // The temperature is displayed in a Text widget.
                    Text(
                      "${weather.currentTemperature.toStringAsFixed(0)}ºC",
                      style: tempStyle,
                    ),
                    // The weather description is displayed in a Text widget.
                    Text(
                      weather.description ?? "",
                      style: regularStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}