import 'package:budget_basket/pages/loading_page.dart';
import 'package:budget_basket/providers/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:budget_basket/pages/basket_builder_page.dart';
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
        home: BasketBuilderPage(),
      ),
    );
  }
}
