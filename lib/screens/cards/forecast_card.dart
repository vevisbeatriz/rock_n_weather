import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rock_n_weather/utilities/constants.dart';
import 'package:weather/weather.dart';

class ForecastCard {
  List<Weather>? _forecast;

  ForecastCard (this._forecast);

Widget _nextDays(int i) {
  return Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            DateFormat("dd/MM  E").format(_forecast![i].date!),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "http://openweathermap.org/img/wn/${_forecast?[i].weatherIcon}.png"),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            _forecast?[i].weatherDescription ?? "",
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            "${_forecast?[i].temperature?.celsius?.toStringAsFixed(0)}ºC",
            textAlign: TextAlign.left,
          ),
        ),
      ],
    ),
  );
}

Widget _forecastCard(int i) {
  return Container(
    height: 80,
    width: double.infinity,
    margin:
    const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0, bottom: 5.0),
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
        color: AppColors.forecastCard,
        borderRadius: BorderRadius.all(Radius.circular(20))),
    child: _nextDays(i),
  );
}
}
