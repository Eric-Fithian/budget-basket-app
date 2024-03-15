import 'dart:convert';
import 'dart:io';
import 'package:budget_basket/models/item.dart';
import 'package:budget_basket/models/store_list.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Item>> getItemsBySearch(
      double lat, double long, double radiusInMiles, String keyword) async {
    // if android then use this url
    var url = Uri.parse('http://localhost:3000/search/items');

    if (Platform.isAndroid) {
      url = Uri.parse('http://10.0.2.2:3000/search/items');
    }
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

  static Future<List<StoreList>> getStoresByLocation(
      double lat, double long, double radiusInMiles) async {
    // if android then use this url
    var url = Uri.parse('http://localhost:3000/search/stores');

    if (Platform.isAndroid) {
      url = Uri.parse('http://10.0.2.2:3000/search/stores');
    }

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "latitude": lat,
        "longitude": long,
        "radiusInMiles": radiusInMiles,
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = json.decode(response.body);
      print("Here: ${jsonData}");
      final List<StoreList> stores = jsonData
          .map<StoreList>(
              (storeData) => StoreList.fromStoreSearchJson(storeData))
          .toList();
      print("Here1: ${stores}");
      return stores;
    } else {
      throw Exception('Failed to load stores');
    }
  }
}
