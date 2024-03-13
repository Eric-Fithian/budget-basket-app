import 'package:budget_basket/api/api_service.dart';
import 'package:budget_basket/components/basket_item.dart';
import 'package:budget_basket/components/shopping_item.dart';
import 'package:budget_basket/models/grocery_store.dart';
import 'package:budget_basket/models/item.dart';
import 'package:budget_basket/models/store_list.dart';
import 'package:budget_basket/pages/loading_page.dart';
import 'package:budget_basket/pages/search_results.dart';
import 'package:budget_basket/providers/shopping_cart_provider.dart';
import 'package:budget_basket/util/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShoppingPage extends StatefulWidget {
  final List<StoreList> storeLists;
  final Position userPosition;

  ShoppingPage(
      {super.key, required this.storeLists, required this.userPosition});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // late Item item1;
  // late Item item2;
  // late Item item3;
  // late Item item4;
  // late Item item5;
  // late Item item6;
  // late Position position;
  // late StoreList storeListWalmart;
  // late StoreList storeListTarget;
  // late List<StoreList> storeLists;

  @override
  void initState() {
    super.initState();

    // item1 = Item(
    //   itemName:
    //       "Organic Bananas Organic Bananas Organic Bananas Organic Bananas",
    //   // itemDescription: "A bunch of organic bananas.",
    //   itemStore: GroceryStore.KingSoopers,
    //   itemDistance: 1.2,
    //   itemPrice: 0.99,
    //   itemSavings: 0.2,
    //   itemImgUrl:
    //       "https://m.media-amazon.com/images/I/81As7EJUNjL._AC_UF1000,1000_QL80_.jpg",
    // );

    // item2 = Item(
    //   itemName: "Almond Milk",
    //   itemDescription: "Unsweetened almond milk.",
    //   itemStore: GroceryStore.Target,
    //   itemDistance: 0.8,
    //   itemPrice: 2.99,
    //   itemSavings: 0.5,
    //   // itemImgUrl: "https://example.com/almond_milk.jpg",
    // );

    // item3 = Item(
    //   itemName: "Organic Strawberries",
    //   itemDescription: "A carton of organic strawberries.",
    //   itemStore: GroceryStore.Walmart,
    //   itemDistance: 1.2,
    //   itemPrice: 2.99,
    //   itemSavings: 0.5,
    //   // itemImgUrl: "https://example.com/strawberries.jpg",
    // );

    // item4 = Item(
    //   itemName: "Organic Avocado",
    //   itemDescription: "A single organic avocado.",
    //   itemStore: GroceryStore.Walmart,
    //   itemDistance: 1.2,
    //   itemPrice: 1.99,
    //   itemSavings: 0.3,
    //   // itemImgUrl: "https://example.com/avocado.jpg",
    // );

    // item5 = Item(
    //   itemName: "Organic Spinach",
    //   itemDescription: "A bag of organic spinach.",
    //   itemStore: GroceryStore.Walmart,
    //   itemDistance: 1.2,
    //   itemPrice: 2.99,
    //   itemSavings: 0.5,
    //   // itemImgUrl: "https://example.com/spinach.jpg",
    // );

    // item6 = Item(
    //   itemName: "Organic Blueberries",
    //   itemDescription: "A carton of organic blueberries.",
    //   itemStore: GroceryStore.Walmart,
    //   itemDistance: 1.2,
    //   itemPrice: 3.99,
    //   itemSavings: 0.7,
    //   // itemImgUrl: "https://example.com/blueberries.jpg",
    // );

    // // Mock position
    // position = Position(
    //   latitude: 37.7749,
    //   longitude: -122.4194,
    //   timestamp: DateTime.now(),
    //   accuracy: 0.0,
    //   altitude: 0.0,
    //   heading: 0.0,
    //   speed: 0.0,
    //   speedAccuracy: 0.0,
    //   altitudeAccuracy: 0.0,
    //   headingAccuracy: 0.0,
    // );

    // // StoreLists
    // storeListWalmart = StoreList(
    //   store: GroceryStore.Target,
    //   location: position,
    //   address: "1234 Elm St, San Francisco, CA 94107",
    //   items: [item1, item3, item4, item5, item6],
    // );

    // storeListTarget = StoreList(
    //   store: GroceryStore.TraderJoes,
    //   location: position,
    //   address: "5678 Oak St, San Francisco, CA 94107",
    //   items: [item2],
    // );

    // // Testing list of StoreLists
    // storeLists = [storeListWalmart, storeListTarget];

    // Initialize the TabController
    _tabController =
        TabController(length: widget.storeLists.length, vsync: this);
    // Add a listener that marks the widget tree as dirty when a new tab is selected
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  void _launchDirections() async {
    // Construct waypoints string
    final waypointsString = super
        .widget
        .storeLists
        .map(
            (store) => '${store.location.latitude},${store.location.longitude}')
        .join('|');

    // Construct the Google Maps web URL for directions
    final googleMapsWebUrl = Uri.encodeFull(
        "https://www.google.com/maps/dir/?api=1&origin=${widget.userPosition.latitude},${widget.userPosition.longitude}&waypoints=$waypointsString&destination=${widget.storeLists.last.location.latitude},${widget.storeLists.last.location.longitude}&travelmode=driving");

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
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
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(0, 0)),
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(MyColors.red),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                PhosphorIcons.mapPin(PhosphorIconsStyle.bold),
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Map",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _launchDirections,
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(0, 0)),
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(MyColors.red),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                PhosphorIcons.path(PhosphorIconsStyle.bold),
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Get Quickest Route",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Personalized Baskets',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: MyColors.black900,
                    indicatorColor: Colors.transparent,
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(right: 10),
                    tabAlignment: TabAlignment.start,
                    tabs: List<Widget>.generate(widget.storeLists.length,
                        (int index) {
                      bool isSelected = _tabController.index == index;
                      return Tab(
                        height: 58,
                        child: Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: isSelected ? MyColors.blue : Colors.white,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.storeLists[index].store.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                widget.storeLists[index].address.length > 15
                                    ? widget.storeLists[index].address
                                            .substring(0, 15) +
                                        '...'
                                    : widget.storeLists[index].address,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: MyColors.black300,
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: widget.storeLists.map((StoreList storeList) {
                        return ListView.builder(
                          // Disables scrolling within the tab
                          itemCount: storeList.items.length,
                          itemBuilder: (context, index) {
                            // Your item widget
                            return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child:
                                    ShoppingItem(item: storeList.items[index]));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(double.infinity, 0)),
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
                  "Done Shopping",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                Expanded(child: SizedBox.shrink()),
                Icon(
                  PhosphorIcons.signOut(PhosphorIconsStyle.bold),
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
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
