import 'package:flutter/material.dart';
import 'package:grocery_getter/objects/Item.dart';
import 'package:grocery_getter/objects/StoreShoppingList.dart';
import 'package:grocery_getter/pages/home.dart';
import 'package:grocery_getter/pages/shoppingPage.dart';
import 'package:grocery_getter/util/tsm.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

// FOR TESTING PURPOSES
// class MainApp extends StatefulWidget {
//   @override
//   _MainAppState createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   List<StoreShoppingList> stores = [];

//   @override
//   void initState() {
//     super.initState();
//     _prepareStores();
//   }

//   void _prepareStores() {
//     stores = [
//       StoreShoppingList(
//         //a
//         latitude: 39.7392, // Denver Art Museum
//         longitude: -104.9903,
//         name: 'Denver Art Museum',
//         items: [
//           Item(name: 'Art Book', price: 29.99),
//           Item(name: 'Poster', price: 15.99),
//           Item(name: 'Souvenir', price: 8.99),
//         ],
//       ),
//       StoreShoppingList(
//         //b
//         latitude: 39.7487, // Denver Zoo
//         longitude: -104.9425,
//         name: 'Denver Zoo',
//         items: [
//           Item(name: 'Zoo Ticket', price: 20),
//           Item(name: 'Zoo Hat', price: 12.99),
//           Item(name: 'Stuffed Animal', price: 19.99),
//         ],
//       ),
//       StoreShoppingList(
//         //c
//         latitude: 39.7333, // Washington Park
//         longitude: -104.9654,
//         name: 'Washington Park',
//         items: [
//           Item(name: 'Frisbee', price: 5.99),
//           Item(name: 'Picnic Blanket', price: 24.99),
//           Item(name: 'Sunscreen', price: 14.99),
//         ],
//       ),
//       StoreShoppingList(
//         //d
//         latitude: 39.7559, // Denver Museum of Nature & Science
//         longitude: -104.9424,
//         name: 'Denver Museum of Nature & Science',
//         items: [
//           Item(name: 'Museum Ticket', price: 18),
//           Item(name: 'Science Kit', price: 29.99),
//           Item(name: 'Dinosaur Toy', price: 22.99),
//         ],
//       ),
//       StoreShoppingList(
//         //e
//         latitude: 39.7480, // Union Station
//         longitude: -104.9977,
//         name: 'Union Station',
//         items: [
//           Item(name: 'Train Ticket', price: 10),
//           Item(name: 'Coffee Mug', price: 13.99),
//           Item(name: 'Book', price: 9.99),
//         ],
//       ),
//       StoreShoppingList(
//         //f
//         latitude: 39.7200, // Denver Botanic Gardens
//         longitude: -104.9565,
//         name: 'Denver Botanic Gardens',
//         items: [
//           Item(name: 'Garden Ticket', price: 12.50),
//           Item(name: 'Plant', price: 30.00),
//           Item(name: 'Gardening Tool', price: 25.99),
//         ],
//       )
//     ];
//     stores = TSM.travelingSalesmanBruteForce(stores, 40.0025817, -105.22805);

//     // Optionally call TSM.travelingSalesmanBruteForce here if you need to process the stores list
//     // Note: travelingSalesmanBruteForce might need to be modified to work asynchronously or in a separate thread
//     // because heavy computations should not block the main thread.
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ShoppingPage(stores: stores),
//     );
//   }
// }
