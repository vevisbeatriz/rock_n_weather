import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:rock_n_weather/screens/cards/weather_card.dart';
import 'package:rock_n_weather/screens/home_page.dart';

import '../mocks/repositories.mocks.dart';
import 'package:rock_n_weather/providers/home_page_provider.dart';
import 'package:rock_n_weather/repositories/models/weather_model.dart';

void main() {
  group('UI Tests', () {
    testWidgets('Home Page Tests', (tester) async {
      MockWeatherRepositoryProtocol mockWeatherRepositoryProtocol =
          MockWeatherRepositoryProtocol();
      HomePageNotifier stateNotifier =
          HomePageNotifier(mockWeatherRepositoryProtocol);

      when(mockWeatherRepositoryProtocol.fetchCurrentWeather(
              cityName: 'Silverstone', countryName: 'UK'))
          .thenAnswer((_) async => WeatherModel(
                cityName: 'Silverstone',
                countryName: 'UK',
                currentTemperature: 10.5,
              ));

      mockNetworkImagesFor(() async {
        await tester.pumpWidget(ProviderScope(
          overrides: [
            homePageProvider.overrideWithProvider(
                StateNotifierProvider<HomePageNotifier, HomePageState>((ref) {
              return stateNotifier;
            })),
          ],
          child: const MaterialApp(
            home: HomePage(),
          ),
        ));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pump();
        expect(tester.widgetList(find.byType(WeatherCard)), [
          isA<WeatherCard>()
              .having(
                  (s) => s.weather.cityName, 'weather.cityName', 'Silverstone')
              .having((s) => s.weather.countryName, 'weather.countryName', 'UK')
              .having((s) => s.weather.currentTemperature,
                  'weather.currentTemperature', 10.5),
        ]);
      });
    });
  });
}
