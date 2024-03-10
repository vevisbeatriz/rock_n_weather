import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rock_n_weather/providers/forecast_page_provider.dart';

class ForecastPage extends ConsumerWidget {
  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastPageModel = ref.watch(forecastPageProvider);

    return Scaffold(
      body: forecastPageModel.forecast == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            // TODO: Add a ListView.builder to display the forecast
            Text("Forecast"),
          ],
        ),
      ),
    );
  }
}
