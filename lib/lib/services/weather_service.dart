import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  String apiKey(String city) {
    return 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$city?unitGroup=metric&key=K5V3K8JXWCCLU88CMVP353YHS&contentType=json';
  }

  Future<dynamic> getCurrentCityWeatherInfo(String city) async {
    try {
      var weatherApiEndpoint = Uri.parse(apiKey(city));
      var response = await http.get(weatherApiEndpoint);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        Map result = jsonDecode(response.body)['currentConditions'];
        return {
          "temperature": result['temp'],
          "condition": result['conditions'],
        };
      } else {
        return null;
      }
    } catch (e) {
      return e;
    }
  }
}
