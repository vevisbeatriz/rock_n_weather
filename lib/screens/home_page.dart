import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rock_n_weather/providers/forecast_page_provider.dart';
import 'package:rock_n_weather/providers/home_page_provider.dart';
import 'package:rock_n_weather/screens/forecast_page.dart';
import 'package:rock_n_weather/screens/cards/weather_card.dart';
import 'package:rock_n_weather/utilities/constants.dart';

/// A widget that displays the home page of the application.
///
/// This is a [ConsumerStatefulWidget], which means it has access to the Riverpod state.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

/// The state for the [HomePage] widget.
///
/// This is where the logic for the home page is implemented.
class _HomePageState extends ConsumerState<HomePage> {
  /// A list of tuples representing the cities for which to fetch the weather.
  final listOfCities = [
    ("Silverstone", "UK"),
    ("Sao Paulo", "BR"),
    ("Melbourne", "AU"),
    ("Monte Carlo", "MC")
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchInitialCitiesWeather();
      //ref.read(homePageProvider.notifier).fetchCitiesWeather(cities: []);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current state of the home page.
    final homePageModel = ref.watch(homePageProvider);
    final searchBarController = TextEditingController();

    searchBarController.text = homePageModel.searchText;
    searchBarController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchBarController.text.length),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.clearSkyLight,
        title: const Text("Rock 'n' Weather"),
        actions: [
          IconButton(
            onPressed:
                homePageModel.homePageStatus == HomePageStatusType.loading
                    ? null
                    : () {
                        // Refresh the weather data when the refresh button is pressed.
                        _fetchInitialCitiesWeather();
                      },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: homePageModel.homePageStatus == HomePageStatusType.loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white,))
          : homePageModel.homePageStatus == HomePageStatusType.error
              ? const Center(child: Text("Error"))
              : SafeArea(
                  child: Column(
                    children: [
                      SearchBar(
                        controller: searchBarController,
                        hintText: "Search for a city",
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        leading: const Icon(Icons.search),
                        trailing: <Widget>[
                          IconButton(
                            onPressed: () {
                              // Clear the search bar and reset the filter when the clear button is pressed.
                              FocusManager.instance.primaryFocus?.unfocus();
                              searchBarController.clear();
                              ref
                                  .read(homePageProvider.notifier)
                                  .filterCitiesWeather(filter: "");
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ],
                        onChanged: (value) async {
                          // Filter the cities based on the search bar text.
                          ref
                              .read(homePageProvider.notifier)
                              .filterCitiesWeather(filter: value);
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                // Fetch the forecast for the selected city and navigate to the forecast page when a city is tapped.
                                ref
                                    .read(forecastPageProvider.notifier)
                                    .fetchForecastWeather(
                                  cityName: homePageModel.citiesWeather![index].cityName,
                                  countryName: homePageModel.citiesWeather![index].countryName,
                                    );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForecastPage(
                                        cityName: homePageModel.citiesWeather![index].cityName),
                                  ),
                                );
                              },
                              child: WeatherCard(
                                  weather: homePageModel.citiesWeather![index]),
                            );
                          },
                          itemCount: homePageModel.citiesWeather!.length,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  /// Fetches the initial weather for the cities in [listOfCities].
  void _fetchInitialCitiesWeather() {
    ref
        .read(homePageProvider.notifier)
        .fetchCitiesWeather(cities: listOfCities);
  }
}
