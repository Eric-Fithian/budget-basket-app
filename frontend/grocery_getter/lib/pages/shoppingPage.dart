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
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            IconButton(
                onPressed: _launchDirections,
                icon: Icon(Icons.directions_car_filled_outlined)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.stores.length,
                itemBuilder: (context, index) {
                  final store = widget.stores[index];
                  return Card(
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      title: Text(store.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      // Removed IconButton from here
                      children: store.items
                          .map((item) => ItemCheckbox(item: item))
                          .toList(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text('New Shopping Trip'),
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
