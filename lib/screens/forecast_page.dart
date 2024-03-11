import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:rock_n_weather/providers/forecast_page_provider.dart';
import 'package:rock_n_weather/utilities/constants.dart';

/// A widget that displays the forecast for a specific city.
///
/// This is a [ConsumerStatefulWidget], which means it has access to the Riverpod state.
class ForecastPage extends ConsumerStatefulWidget {
  const ForecastPage({super.key, required this.cityName});

  final String cityName;

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

/// The state for the [ForecastPage] widget.
///
/// This is where the logic for the forecast page is implemented.
class _ForecastPageState extends ConsumerState<ForecastPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Fetch the forecast for the specified city when the widget is first created.
      ref.read(forecastPageProvider.notifier).fetchForecastWeather(
            cityName: widget.cityName,
            countryName: "UK",
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current state of the forecast page.
    final forecastPageModel = ref.watch(forecastPageProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.clearSkyLight,
        title: Text(widget.cityName),
      ),
      body: forecastPageModel.forecastPageStatus == ForecastStatusType.loading
          ? const Center(child: CircularProgressIndicator())
          : forecastPageModel.forecastPageStatus == ForecastStatusType.error
              ? const Center(child: Text("Error"))
              : SafeArea(
                  child: GroupedListView(
                  // Sort the forecast by date and group it by day.
                  elements: forecastPageModel.forecast!
                    ..sort((a, b) => a.date!.compareTo(b.date!)),
                  groupBy: (element) =>
                      DateFormat('yyyy-MM-dd').format(element.date!),
                  groupSeparatorBuilder: (String groupByValue) => Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Text(
                      DateFormat('EEE, MMM d')
                          .format(DateFormat('yyyy-MM-dd').parse(groupByValue)),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // For each forecast, display a card with the weather icon, time, description, and temperature.
                  itemBuilder: (context, dynamic element) {
                    final weather = element;
                    return Card(
                      margin: const EdgeInsets.all(7.0),
                      child: ListTile(
                        leading: Image.network(
                          "http://openweathermap.org/img/wn/${weather.icon}@4x.png",
                        ),
                        title: Text(DateFormat('HH:mm').format(weather.date!),
                            style: TextStyle(fontSize: 16)),
                        subtitle: Text(weather.description!,
                            style: TextStyle(fontSize: 14)),
                        trailing: Text("${weather.currentTemperature}°C",
                            style: TextStyle(fontSize: 16)),
                      ),
                    );
                  },
                )),
    );
  }
}
