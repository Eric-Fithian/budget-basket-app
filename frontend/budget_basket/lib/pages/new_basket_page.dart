import 'package:budget_basket/api/api_service.dart';
import 'package:budget_basket/components/basket_item.dart';
import 'package:budget_basket/models/item.dart';
import 'package:budget_basket/models/store_list.dart';
import 'package:budget_basket/pages/basket_builder_page.dart';
import 'package:budget_basket/pages/loading_page.dart';
import 'package:budget_basket/pages/search_results.dart';
import 'package:budget_basket/pages/shopping_page.dart';
import 'package:budget_basket/providers/shopping_cart_provider.dart';
import 'package:budget_basket/util/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class NewBasketPage extends StatefulWidget {
  const NewBasketPage({
    super.key,
  });

  @override
  State<NewBasketPage> createState() => _NewBasketPageState();
}

class _NewBasketPageState extends State<NewBasketPage> {
  int _maxStoreVisits = 3;
  double _radiusInMiles = 5;

  void _updateMaxStoreVisits(double value) {
    setState(() {
      _maxStoreVisits = value.toInt();
    });
  }

  void _updateRadiusInMiles(double value) {
    setState(() {
      _radiusInMiles = value;
    });
  }

  void _startNewBasket() async {
    // Request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returns true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingPage(),
      ),
    );

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print("User's position: $position");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BasketBuilderPage(
          userPosition: position,
          radiusInMiles: 10,
          maxNumberOfStores: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.blue,
        title: Text(
          'Budget Basket',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 19.0,
          ),
        ),
        centerTitle: true, // Center the title
        leading: Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 20),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'New\nBudget\nBasket',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 64,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Shopping Preferences',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 29,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // add a slider
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Maximum Store Visits',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                        Expanded(child: SizedBox.shrink()),
                        Text(
                          '$_maxStoreVisits',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  // add a slider
                  SliderTheme(
                    data: SliderThemeData(
                      //make track take full width

                      // Change the active track color
                      activeTrackColor: MyColors.blue,
                      // Change the inactive track color
                      inactiveTrackColor: MyColors.blue.withOpacity(0.3),
                      // Change the thumb color
                      thumbColor: MyColors.blue,
                      // Change the overlay color (shown when the thumb is pressed)
                      overlayColor: Colors.transparent,
                      // Change the track height (thickness)
                      trackHeight: 4.0,
                      // Customize the thumb shape
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                      // Customize the overlay shape
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                      // Customize the value indicator shape
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      // Change the value indicator color
                      valueIndicatorColor: MyColors.blue,
                      // Customize the tick marks (shown when divisions are set)
                      tickMarkShape: RoundSliderTickMarkShape(),
                      // Change the active tick mark color
                      activeTickMarkColor: MyColors.blue,
                      // Change the inactive tick mark color
                      inactiveTickMarkColor: MyColors.blue.withOpacity(0.3),
                    ),
                    child: Slider(
                      value: _maxStoreVisits.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      onChanged: (double value) => _updateMaxStoreVisits(value),
                      label: '${_maxStoreVisits.toInt()}',
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Maximum Store Distance',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                        Expanded(child: SizedBox.shrink()),
                        Text(
                          '$_radiusInMiles mi',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  // add a slider
                  SliderTheme(
                    data: SliderThemeData(
                      // Change the active track color
                      activeTrackColor: MyColors.blue,
                      // Change the inactive track color
                      inactiveTrackColor: MyColors.blue.withOpacity(0.3),
                      // Change the thumb color
                      thumbColor: MyColors.blue,
                      // Change the overlay color (shown when the thumb is pressed)
                      overlayColor: Colors.transparent,
                      // Change the track height (thickness)
                      trackHeight: 4.0,
                      // Customize the thumb shape
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                      // Customize the overlay shape
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                      // Customize the value indicator shape
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      // Change the value indicator color
                      valueIndicatorColor: MyColors.blue,
                      // Customize the tick marks (shown when divisions are set)
                      tickMarkShape: RoundSliderTickMarkShape(),
                      // Change the active tick mark color
                      activeTickMarkColor: MyColors.blue,
                      // Change the inactive tick mark color
                      inactiveTickMarkColor: MyColors.blue.withOpacity(0.3),
                    ),
                    child: Slider(
                      value: _radiusInMiles.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (double value) => _updateRadiusInMiles(value),
                      label: '${_radiusInMiles.toInt()}',
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Consumer<ShoppingCartProvider>(
              builder: (context, shoppingCartProvider, child) {
            return ElevatedButton(
              onPressed: _startNewBasket,
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 0)),
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(MyColors.red),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Start New Basket",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  Expanded(child: SizedBox.shrink()),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(-1.0, 1.0), // This flips the icon horizontally
                    child: Icon(
                      PhosphorIcons.wind(PhosphorIconsStyle.regular),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Icon(
                    PhosphorIcons.shoppingCart(PhosphorIconsStyle.regular),
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: MyColors.black100,
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: 1,
              elevation: 0,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIcons.house(), size: 28),
                  label: 'Basket',
                ),
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIcons.basket(PhosphorIconsStyle.fill),
                      size: 28),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIcons.user(), size: 28),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: MyColors.blue,
              unselectedItemColor: MyColors.blue,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
      backgroundColor: MyColors.black100,
    );
  }
}
