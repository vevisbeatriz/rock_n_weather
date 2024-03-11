import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rock_n_weather/providers/forecast_page_provider.dart';
import 'package:rock_n_weather/providers/home_page_provider.dart';
import 'package:rock_n_weather/screens/forecast_page.dart';
import 'package:rock_n_weather/screens/cards/weather_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
    final homePageModel = ref.watch(homePageProvider);
    final searchBarController = TextEditingController();

    searchBarController.text = homePageModel.searchText;
    searchBarController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchBarController.text.length),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rock 'n' Weather"),
        actions: [
          IconButton(
            onPressed:
                homePageModel.homePageStatus == HomePageStatusType.loading
                    ? null
                    : () {
                        _fetchInitialCitiesWeather();
                      },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: homePageModel.homePageStatus == HomePageStatusType.loading
          ? const Center(child: CircularProgressIndicator())
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
                                ref
                                    .read(forecastPageProvider.notifier)
                                    .fetchForecastWeather(
                                      cityName: listOfCities[index].$1,
                                      countryName: listOfCities[index].$2,
                                    );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForecastPage(cityName: listOfCities[index].$1),
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

  void _fetchInitialCitiesWeather() {
    ref
        .read(homePageProvider.notifier)
        .fetchCitiesWeather(cities: listOfCities);
  }
}
