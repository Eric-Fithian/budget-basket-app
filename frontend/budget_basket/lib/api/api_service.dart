import 'dart:convert';
import 'package:budget_basket/models/item.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Item>> getItemsBySearch(
      double lat, double long, double radiusInMiles, String keyword) async {
    final url = Uri.parse('http://10.0.2.2:3000/search/items');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "latitude": lat,
        "longitude": long,
        "radiusInMiles": radiusInMiles,
        "keyword": keyword,
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<Item> items =
          jsonData.map<Item>((itemData) => Item.fromJson(itemData)).toList();
      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }
}
