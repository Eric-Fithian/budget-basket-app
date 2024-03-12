import 'package:budget_basket/models/grocery_store.dart';

class Item {
  final String itemName;
  final String? itemDescription;
  final GroceryStore itemStore;
  final double itemDistance;
  final double itemPrice;
  final double? itemSavings;
  final String? itemImgUrl;

  Item({
    required this.itemName,
    this.itemDescription,
    required this.itemStore,
    required this.itemDistance,
    required this.itemPrice,
    this.itemSavings,
    this.itemImgUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    print("ITEM: $json");
    return Item(
      itemName: json['name'],
      itemDescription: json['description'],
      itemStore: GroceryStore.values.firstWhere(
          (e) => e.toString() == 'GroceryStore.${json['groceryStoreName']}'),
      itemDistance: json['distance'],
      itemPrice: json['price'],
      itemSavings: null,
      itemImgUrl: json['img'],
    );
  }
}
