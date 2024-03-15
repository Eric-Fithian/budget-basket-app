import 'package:budget_basket/models/grocery_store.dart';
import 'package:budget_basket/models/item.dart';
import 'package:geolocator/geolocator.dart';

class StoreList {
  final GroceryStore store;
  final Position location;
  final String address;
  List<Item> items;

  StoreList({
    required this.store,
    required this.location,
    required this.address,
    required this.items,
  });

  factory StoreList.fromStoreSearchJson(Map<String, dynamic> json) {
    final store = GroceryStore.values.firstWhere((e) =>
        e.toString().toLowerCase() ==
        'GroceryStore.${json['name']}'.toLowerCase());
    final location = Position(
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
      //initilize rest to 0
      altitude: 0,
      speed: 0,
      speedAccuracy: 0,
      heading: 0,
      accuracy: 0,
      floor: 0,
      timestamp: DateTime.now(),
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    final address = json['address'];
    final items = <Item>[];

    return StoreList(
      store: store,
      location: location,
      address: address,
      items: items,
    );
  }
}
