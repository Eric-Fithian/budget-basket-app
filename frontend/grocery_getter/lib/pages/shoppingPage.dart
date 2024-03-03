import 'package:flutter/material.dart';
import 'package:grocery_getter/objects/Item.dart';
import 'package:grocery_getter/objects/StoreShoppingList.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<StoreShoppingList> stores = [
    StoreShoppingList(
      latitude: 34.0522,
      longitude: -118.2437,
      name: "Store A",
      items: [
        Item(name: "Apples", price: 1.99),
        Item(name: "Bananas", price: 0.99),
      ],
    ),
    StoreShoppingList(
      latitude: 40.7128,
      longitude: -74.0060,
      name: "Store B",
      items: [
        Item(name: "Oranges", price: 2.99),
        Item(name: "Grapes", price: 2.50),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: stores.length,
          itemBuilder: (context, index) {
            final store = stores[index];
            return Card(
              child: ListTile(
                title: Text(store.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: store.items.map((item) => Text('• ${item.name}, Esitmated Price: \$${item.price}', style: TextStyle(fontSize: 16))).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
