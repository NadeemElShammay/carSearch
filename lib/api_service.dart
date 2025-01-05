import 'dart:convert';
import 'package:http/http.dart' as http;
import 'car.dart';

class ApiService {
  static const String apiUrl = 'http://localhost/carsearchprice/car_search.php';

  static Future<List<Car>> fetchCars() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Car.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load cars');
    }
  }
}
