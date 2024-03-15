import 'package:budget_basket/models/UnitOfMeasurement.dart';
import 'package:budget_basket/models/grocery_store.dart';

class Item {
  final String itemName;
  final String? itemDescription;
  final GroceryStore itemStore;
  final double itemDistance;
  final double itemPrice;
  final double? itemSavings;
  final String? itemImgUrl;
  final double unitAmount;
  final double normalizedPrice;
  final UnitOfMeasurement unitOfMeasurement;
  var isChecked = false;

  Item({
    required this.itemName,
    this.itemDescription,
    required this.itemStore,
    required this.itemDistance,
    required this.itemPrice,
    this.itemSavings,
    this.itemImgUrl,
    required this.unitAmount,
    required this.normalizedPrice,
    required this.unitOfMeasurement,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    print("ITEM: $json");
    final itemName = json['name'];
    final itemDescription = json['description'];
    final itemStore = GroceryStore.values.firstWhere((e) =>
        e.toString().toLowerCase() ==
        'GroceryStore.${json['groceryStoreName']}'.toLowerCase());
    final itemDistance = json['distance'].toDouble();
    final itemPrice = json['price'].toDouble();
    final itemSavings = json['savings']?.toDouble();
    final itemImgUrl = json['img'];
    final unitAmount = json['unitAmount'].toDouble();
    final normalizedPrice = json['normalizedPrice'].toDouble();
    final unitOfMeasurement = UnitOfMeasurement.values.firstWhere((e) =>
        e.toString() == 'UnitOfMeasurement.${json['unitOfMeasurement']}');

    return Item(
      itemName: itemName,
      itemDescription: itemDescription,
      itemStore: itemStore,
      itemDistance: itemDistance,
      itemPrice: itemPrice,
      itemSavings: itemSavings,
      itemImgUrl: itemImgUrl,
      unitAmount: unitAmount,
      normalizedPrice: normalizedPrice,
      unitOfMeasurement: unitOfMeasurement,
    );
  }
}
