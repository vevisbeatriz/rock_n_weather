# Rock N Weather

## Description
Rock N Weather is a weather tracking application designed for a rock'n'roll band staff. It provides current weather information in a user-friendly manner.
- The app uses riverpod for state management. Although the app is small and setState would be enough, I wanted to demonstrate my knowledge of riverpod.
- Although I could use the weather plugin, I decided to use the OpenWeatherMap API directly to demonstrate my knowledge of making API requests and parsing JSON data.

## TODO
Although the app is functional, there are a few things that I would like to improve:
- Adjust the date and time format for the timezones of the cities.
- Show min and max temperatures in the home page.
- Add more tests.

## Installation
To install the project, clone the repository and open it in Android Studio. Make sure you have the Dart and Flutter plugins installed.

## Usage
The application starts with the home page where you can navigate to the forecast page to see the weather information. The weather information includes the current temperature and a description of the weather.
Touching one of the cities in the forecast page will display the weather forecast for the next 5 days, every 3 hours.

## Project Structure
The project is structured as follows:

- `lib/`: This is the main directory where all the Dart code resides.
    - `main.dart`: This is the entry point of the application. It initializes the Injector for dependency injection and starts the application with the ProviderScope widget.
    - `utilities/`: This directory contains utility classes and constants used throughout the application.
        - `constants.dart`: This file contains the constants used in the application, including the app colors and text styles.
    - `repositories/`: This directory contains the data layer of the application, including models and repositories.
        - `models/`: This directory contains the data models used in the application.
            - `weather_model.dart`: This file defines the WeatherModel class which models the weather in a city.
        - `weather_repository.dart`: This file contains the WeatherRepository class which is responsible for fetching weather data.
    - `screens/`: This directory contains the screens of the application, including the home page and the forecast page.
        - `home_page.dart`: This file contains the HomePage widget which is the first screen that the user sees when they open the application.
        - `forecast_page.dart`: This file contains the ForecastPage widget which displays the weather forecast.
    - `providers/`: This directory contains the state management logic for the application.
        - `forecast_page_provider.dart`: This file contains the ForecastPageProvider class which manages the state for the ForecastPage.

## Technologies Used
- Flutter
- Dart