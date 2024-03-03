import "package:flutter/material.dart";
import 'package:grocery_getter/objects/StoreShoppingList.dart';
import 'package:grocery_getter/pages/shoppingPage.dart';
import 'package:grocery_getter/util/tsm.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:io' show Platform;
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> groceries = [""];

  void _updateGroceryItem(String newName, int index) {
    setState(() {
      groceries[index] = newName;
    });
  }

  void _addNewGroceryItem() {
    setState(() {
      groceries.add(""); // Add a new blank item
    });
  }

  String getBackendUrl() {
    // Use 10.0.2.2 for Android emulator and localhost for iOS simulator
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/route';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000/route';
    } else {
      throw UnsupportedError('This platform is not supported');
    }
  }

  // Method to handle the "Submit" action
  void _handleSubmit() async {
    //remove empty strings from the list
    groceries.removeWhere((element) => element.isEmpty);
    if (groceries.isEmpty) {
      return;
    }

    var location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    // Check if location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Location services are disabled.');
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('Location permission denied.');
        return; // Exit the function if permission is denied
      }
    }

    // Get current location
    _locationData = await location.getLocation();

    // Use the getBackendUrl method to determine the correct URL
    var backendUrl = getBackendUrl();
    var url = Uri.parse(backendUrl); // Use the dynamically determined URL here
    var radius = 10; // Example in miles

    try {
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'latitude': _locationData.latitude,
            'longitude': _locationData.longitude,
            'radius': radius,
            'items': groceries,
          }));

      if (response.statusCode == 200) {
        print('List submitted successfully');
        // Assuming StoreShoppingList is defined and ShoppingPage takes a list of StoreShoppingList
        List<StoreShoppingList> stores = (jsonDecode(response.body) as List)
            .map((i) => StoreShoppingList.fromJson(i))
            .toList();

        // Call the travelingSalesmanBruteForce method
        stores = TSM.travelingSalesmanBruteForce(
            stores, _locationData.latitude!, _locationData.longitude!);
        // Navigate to a new page after submission
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShoppingPage(stores: stores)));
      } else {
        print('Failed to submit the list');
        // Handle the error scenario
      }
    } catch (e) {
      print('Error making the API call: $e');
      // Handle exception when making the API call
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          // This Column wraps the entire layout
          children: [
            Expanded(
              // This Expanded widget contains the SingleChildScrollView
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "GroceryGetter",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap:
                            true, // Allows ListView to be used within SingleChildScrollView
                        physics:
                            NeverScrollableScrollPhysics(), // Disables scrolling within ListView
                        itemCount: groceries.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == groceries.length) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: _addNewGroceryItem,
                                child: Text('Add Another Item'),
                              ),
                            );
                          }
                          return GroceryListItem(
                            name: groceries[index],
                            onNameChanged: (newName) =>
                                _updateGroceryItem(newName, index),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('Lets Go Shopping!'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroceryListItem extends StatefulWidget {
  final String name;
  final Function(String) onNameChanged;

  const GroceryListItem(
      {super.key, required this.name, required this.onNameChanged});

  @override
  _GroceryListItemState createState() => _GroceryListItemState();
}

class _GroceryListItemState extends State<GroceryListItem> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 8.0), // Add some vertical spacing between items
      padding: EdgeInsets.all(8.0), // Add padding inside the container
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color to white
        borderRadius: BorderRadius.circular(10), // Apply border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.1), // Drop shadow with reduced opacity
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // Position of the shadow
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none, // Remove underline border in text field
          hintText: 'Enter item name',
        ),
        onChanged: widget.onNameChanged,
      ),
    );
  }
}
