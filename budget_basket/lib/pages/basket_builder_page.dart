import 'package:budget_basket/api/api_service.dart';
import 'package:budget_basket/components/basket_item.dart';
import 'package:budget_basket/models/item.dart';
import 'package:budget_basket/models/store_list.dart';
import 'package:budget_basket/pages/loading_page.dart';
import 'package:budget_basket/pages/search_results.dart';
import 'package:budget_basket/pages/shopping_page.dart';
import 'package:budget_basket/providers/shopping_cart_provider.dart';
import 'package:budget_basket/assets/my_colors.dart';
import 'package:budget_basket/util/item_sorter.dart';
import 'package:budget_basket/util/traveling_sales_man.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class BasketBuilderPage extends StatefulWidget {
  final Position userPosition;
  final double radiusInMiles;
  final int maxNumberOfStores;

  const BasketBuilderPage({
    super.key,
    required this.userPosition,
    required this.radiusInMiles,
    required this.maxNumberOfStores,
  });

  @override
  State<BasketBuilderPage> createState() => _BasketBuilderPageState();
}

class _BasketBuilderPageState extends State<BasketBuilderPage> {
  final TextEditingController _searchController = TextEditingController();
  List<StoreList> storeLists = [];

  void _onSearchSubmitted(String value) async {
    print('Submitted: $value');
    // Use Navigator to push to the new page when the user submits the text field
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => LoadingPage()), // Direct navigation
      // For named routes, use: Navigator.of(context).pushNamed('/newPage');
    );

    try {
      if (storeLists.isEmpty) {
        print('Getting stores by location');
        // Perform the API call
        storeLists = await ApiService.getStoresByLocation(
            widget.userPosition.latitude,
            widget.userPosition.longitude,
            widget.radiusInMiles);
      }

      // Perform the API call
      final itemResults =
          await ApiService.getItemsBySearch(40.0150, -105.2705, 10, value);

      final sortedItemResults = ItemSorter.sortByNormalizedPrice(itemResults);

      for (var item in sortedItemResults) {
        print('${item.itemName}: ${item.normalizedPrice}');
      }

      // Once the API call is done, replace the loading page with the new page, passing the API response
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => SearchResultsPage(
                items: sortedItemResults,
                searchTerm: value,
              )));
      _searchController.clear();
    } catch (error) {
      // Handle any errors here
      // For example, pop the loading page and show an error message
      print('Error: $error');
      Navigator.of(context).pop(); // Go back from the loading page
      // Show an error message, e.g., using a SnackBar
    }
  }

  void _onLetGoShopping(List<Item> items) async {
    // add items to their lists
    for (Item item in items) {
      for (var storeList in storeLists) {
        if (storeList.store == item.itemStore) {
          storeList.items.add(item);
        }
      }
    }

    //clean storeLists of lists with no items
    storeLists.removeWhere((storeList) => storeList.items.isEmpty);

    storeLists = TravelingSalesMan.travelingSalesmanBruteForce(storeLists,
        widget.userPosition.latitude, widget.userPosition.longitude);

    // Implement the navigation to the shopping page here
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ShoppingPage(
              storeLists: storeLists, userPosition: widget.userPosition)),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<ShoppingCartProvider>(
          builder: (context, shoppingCartProvider, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 20),
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
                            'Search Items',
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: MyColors.black800, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            // Wrap the TextField in an Expanded widget to ensure it fills the space
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: MyColors.black700,
                                  fontSize: 15,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none, // Removes underline
                                isDense: true, // Adds vertical density
                                contentPadding:
                                    EdgeInsets.zero, // Reduces default padding
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              onSubmitted: _onSearchSubmitted,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                                // If you want to style this container, do it here.
                                ),
                            child: Icon(
                              PhosphorIcons.magnifyingGlass(
                                  PhosphorIconsStyle.regular),
                              color: MyColors.black700,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
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
                            'Current Basket',
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
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: shoppingCartProvider.items.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: BasketItem(
                            key: ValueKey(shoppingCartProvider.items[index]),
                            itemName:
                                shoppingCartProvider.items[index].itemName,
                            itemDescription: shoppingCartProvider
                                .items[index].itemDescription,
                            itemStore:
                                shoppingCartProvider.items[index].itemStore,
                            itemDistance:
                                shoppingCartProvider.items[index].itemDistance,
                            itemPrice:
                                shoppingCartProvider.items[index].itemPrice,
                            itemSavings:
                                shoppingCartProvider.items[index].itemSavings,
                            itemImgUrl:
                                shoppingCartProvider.items[index].itemImgUrl,
                            isInCart: true,
                            onPressed: () {
                              shoppingCartProvider.removeItem(
                                  shoppingCartProvider.items[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Consumer<ShoppingCartProvider>(
              builder: (context, shoppingCartProvider, child) {
            return ElevatedButton(
              onPressed: () => _onLetGoShopping(shoppingCartProvider.items),
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
                    "Let's Go Shopping!",
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
