import 'package:grocery_getter/objects/Item.dart';

class StoreShoppingList {
  double latitude;
  double longitude;
  String name;
  List<Item> items;

  StoreShoppingList({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.items
  });


  factory StoreShoppingList.fromJSON(Map<String, dynamic> json) {
    return StoreShoppingList(
      latitude: json['latitude'].toDouble(), // Ensure this is a double
      longitude: json['longitude'].toDouble(), // Ensure this is a double
      name: json['name'],
      items: List<Item>.from(json['items'].map((itemJson) => Item.fromJSON(itemJson))),
    );
  }
}