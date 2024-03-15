import 'package:budget_basket/models/grocery_store.dart';
import 'package:budget_basket/models/item.dart';
import 'package:budget_basket/models/store_list.dart';
import 'package:budget_basket/pages/loading_page.dart';
import 'package:budget_basket/pages/new_basket_page.dart';
import 'package:budget_basket/pages/shopping_page.dart';
import 'package:budget_basket/providers/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:budget_basket/pages/basket_builder_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ShoppingCartProvider()),
      ],
      child: MaterialApp(
        home: NewBasketPage(),
        // home: BasketBuilderPage(
        //   userPosition: Position(
        //     latitude: 40.0150,
        //     longitude: -105.2705,
        //     altitude: 0,
        //     speed: 0,
        //     speedAccuracy: 0,
        //     heading: 0,
        //     accuracy: 0,
        //     floor: 0,
        //     timestamp: DateTime.now(),
        //     altitudeAccuracy: 0,
        //     headingAccuracy: 0,
        //   ),
        //   radiusInMiles: 10,
        //   maxNumberOfStores: 10,
        // ),
        // home: ShoppingPage(storeLists: []),
      ),
    );
  }
}
