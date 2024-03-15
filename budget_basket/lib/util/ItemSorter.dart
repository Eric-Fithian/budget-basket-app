import 'package:budget_basket/models/item.dart';

class ItemSorter {
  static List<Item> sortByPrice(List<Item> items) {
    items.sort((a, b) => a.itemPrice.compareTo(b.itemPrice));
    return items;
  }

  static List<Item> sortByNormalizedPrice(List<Item> items) {
    items.sort((a, b) => a.normalizedPrice.compareTo(b.normalizedPrice));
    return items;
  }
}
