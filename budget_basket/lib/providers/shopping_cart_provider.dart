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

  void clearItems() {
    _items.clear();
    notifyListeners();
  }
}
