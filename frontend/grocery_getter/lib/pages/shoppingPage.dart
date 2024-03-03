import 'package:flutter/material.dart';
import 'package:grocery_getter/objects/Item.dart';
import 'package:grocery_getter/objects/StoreShoppingList.dart';
import 'package:grocery_getter/pages/home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class ShoppingPage extends StatefulWidget {
  final List<StoreShoppingList> stores;

  ShoppingPage({Key? key, required this.stores}) : super(key: key);

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  // Method to launch directions in a map application
  void _launchDirections() async {
    // Check if location services are enabled and ask for permission
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle this case
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle this case
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle this case
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition();

    // Construct waypoints string
    final waypointsString = super
        .widget
        .stores
        .map((store) => '${store.latitude},${store.longitude}')
        .join('|');

    // Construct the Google Maps web URL for directions
    final googleMapsWebUrl = Uri.encodeFull(
        "https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&waypoints=$waypointsString&destination=${super.widget.stores.last.latitude},${super.widget.stores.last.longitude}&travelmode=driving");

    // Attempt to launch the Google Maps web URL
    if (await canLaunchUrl(Uri.parse(googleMapsWebUrl))) {
      await launchUrl(Uri.parse(googleMapsWebUrl));
    } else {
      throw 'Could not launch URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 12),
              child: Text(
                'Personalized Shopping List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(), // Add this line
                      shrinkWrap: true, // Add this line
                      itemCount: widget.stores.length,
                      itemBuilder: (context, index) {
                        final store = widget.stores[index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 42, 60, 62)
                                    .withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ExpansionTile(
                            iconColor: Colors.black,
                            backgroundColor: Color.fromARGB(255, 233, 255, 228),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            title: Text(store.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            children: store.items
                                .map((item) => ItemCheckbox(item: item))
                                .toList(),
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 241, 208, 208),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 62, 42, 42)
                                .withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                          child: Text(
                            'Done Shopping',
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
                  ],
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
                  color: Color.fromARGB(255, 208, 241, 234),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 42, 60, 62).withOpacity(0.15),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text(
                      'Map Shortest Route',
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
      ),
    );
  }
}

class ItemCheckbox extends StatefulWidget {
  final Item item;

  ItemCheckbox({Key? key, required this.item}) : super(key: key);

  @override
  _ItemCheckboxState createState() => _ItemCheckboxState();
}

class _ItemCheckboxState extends State<ItemCheckbox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: widget.item.isChecked,
      activeColor: const Color.fromARGB(255, 0, 0, 0),
      checkColor: Colors.transparent,
      checkboxShape: CircleBorder(),
      title:
          Text('${widget.item.name}, Estimated Price: \$${widget.item.price}'),
      onChanged: (bool? value) {
        setState(() {
          widget.item.isChecked = value!;
        });
      },
    );
  }
}
