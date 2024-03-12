import 'package:budget_basket/models/grocery_store.dart';
import 'package:flutter/widgets.dart';

class MyLogos {
  static Image getLogoImage(GroceryStore store) {
    return Image.asset(
      'assets/logos/${store.toString().split('.').last}.png',
    );
  }
}
