import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:grocery_getter/pages/shoppingPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> groceries = ["Banana", "Orange", "Monkey"];

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

  // Method to handle the "Submit" action
  void _handleSubmit() {
    // Implement your API call and redirection logic here
    print('Submitting the list...');
    // Navigate to a new page after submission, for example:
    Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Column( // This Column wraps the entire layout
          children: [
            Expanded( // This Expanded widget contains the SingleChildScrollView
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
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5),
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
                        shrinkWrap: true, // Allows ListView to be used within SingleChildScrollView
                        physics: NeverScrollableScrollPhysics(), // Disables scrolling within ListView
                        itemCount: groceries.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == groceries.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: _addNewGroceryItem,
                                child: Text('Add Another Item'),
                              ),
                            );
                          }
                          return GroceryListItem(
                            name: groceries[index],
                            onNameChanged: (newName) => _updateGroceryItem(newName, index),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.blue),
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50), // makes the button larger
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

  const GroceryListItem({super.key, required this.name, required this.onNameChanged});

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
      margin: EdgeInsets.symmetric(vertical: 8.0), // Add some vertical spacing between items
      padding: EdgeInsets.all(8.0), // Add padding inside the container
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color to white
        borderRadius: BorderRadius.circular(10), // Apply border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Drop shadow with reduced opacity
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


