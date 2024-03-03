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
  bool _isLoading = false;
  List<String> groceries = [""];

  void _updateGroceryItem(String newName, int index) {
    setState(() {
      groceries[index] = newName;
    });
  }

  void _addNewGroceryItem() {
    if (groceries.isNotEmpty && groceries.last.isEmpty) {
      return; // Prevent adding a new item if the last one is already empty
    }
    setState(() {
      groceries.add("");
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
    setState(() {
      _isLoading = true; // Start loading
    });
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
        setState(() {
          _isLoading = false; // Stop loading after the API call is complete
        });
        // Navigate to a new page after submission
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShoppingPage(stores: stores)));
      } else {
        setState(() {
          _isLoading = false; // Stop loading after the API call is complete
        });
        print('Failed to submit the list');
        // Handle the error scenario
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading after the API call is complete
      });
      print('Error making the API call: $e');
      // Handle exception when making the API call
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          Column(
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
                        SizedBox(height: 24),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "GroceryGetter",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        //insert image here
                        Image.asset(
                          "assets/globe3.png",
                          width: 280,
                          height: 280,
                        ),
                        Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        ListView.builder(
                          shrinkWrap:
                              true, // Allows ListView to be used within SingleChildScrollView
                          physics:
                              NeverScrollableScrollPhysics(), // Disables scrolling within ListView
                          itemCount: groceries.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GroceryListItem(
                              name: groceries[index],
                              onNameChanged: (newName) =>
                                  _updateGroceryItem(newName, index),
                              isLastItem: index == groceries.length - 1,
                              onAddItem:
                                  _addNewGroceryItem, // Pass the method as a callback
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 208, 241,
                        234), // Set the background color to white
                    borderRadius:
                        BorderRadius.circular(10), // Apply border radius
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 42, 60, 62).withOpacity(
                            0.15), // Drop shadow with reduced opacity
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Position of the shadow
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: _handleSubmit,
                      child: Text(
                        'Let\'s Go Shopping!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity,
                            30), // makes button expand horizontally
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading) // Conditional rendering
            Center(
              child:
                  CircularProgressIndicator(), // Display loading indicator in the center
            ),
        ]),
      ),
    );
  }
}

class GroceryListItem extends StatefulWidget {
  final String name;
  final Function(String) onNameChanged;
  final bool isLastItem; // Add this line
  final VoidCallback onAddItem; // Add this line

  const GroceryListItem(
      {super.key,
      required this.name,
      required this.onNameChanged,
      required this.isLastItem,
      required this.onAddItem});

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
        padding: EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 16), // Add padding inside the container
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
            border: InputBorder.none,
            hintText: 'Enter item name',
          ),
          onChanged: (value) {
            widget.onNameChanged(value);
            if (widget.isLastItem && value.isNotEmpty) {
              widget
                  .onAddItem(); // Use the callback instead of directly accessing the parent state
            }
          },
        ));
  }
}
