import 'package:budget_basket/models/grocery_store.dart';
import 'package:budget_basket/models/item.dart';
import 'package:flutter/foundation.dart';

class ShoppingCartProvider with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(Item item) {
    _items.remove(item);
    notifyListeners();
  }
}

List<Item> generateItems(int count) {
  List<Item> items = [];

  for (int i = 0; i < count; i++) {
    items.add(
      Item(
        itemName: "Item $i",
        itemDescription: "Description for item $i",
        itemStore: GroceryStore.KingSoopers,
        itemDistance: 0.77,
        itemPrice: 3.99,
        itemSavings: 1.29,
        itemImgUrl:
            "https://m.media-amazon.com/images/I/81As7EJUNjL._SX679_.jpg",
      ),
    );
  }

  return items;
}
