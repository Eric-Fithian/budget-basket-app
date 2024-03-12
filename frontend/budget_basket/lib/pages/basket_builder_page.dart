import 'package:budget_basket/api/api_service.dart';
import 'package:budget_basket/components/basket_item.dart';
import 'package:budget_basket/pages/loading_page.dart';
import 'package:budget_basket/pages/search_results.dart';
import 'package:budget_basket/providers/shopping_cart_provider.dart';
import 'package:budget_basket/util/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class BasketBuilderPage extends StatefulWidget {
  const BasketBuilderPage({Key? key}) : super(key: key);

  @override
  State<BasketBuilderPage> createState() => _BasketBuilderPageState();
}

class _BasketBuilderPageState extends State<BasketBuilderPage> {
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
                              onSubmitted: (String value) async {
                                print('Submitted: $value');
                                // Use Navigator to push to the new page when the user submits the text field
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoadingPage()), // Direct navigation
                                  // For named routes, use: Navigator.of(context).pushNamed('/newPage');
                                );

                                try {
                                  // Perform the API call
                                  final itemResults =
                                      await ApiService.getItemsBySearch(
                                          40.0150, -105.2705, 10, value);

                                  // Once the API call is done, replace the loading page with the new page, passing the API response
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (_) => SearchResultsPage(
                                                items: itemResults,
                                                searchTerm: value,
                                              )));
                                } catch (error) {
                                  // Handle any errors here
                                  // For example, pop the loading page and show an error message
                                  print('Error: $error');
                                  Navigator.of(context)
                                      .pop(); // Go back from the loading page
                                  // Show an error message, e.g., using a SnackBar
                                }
                              },
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
                              Icons.search,
                              color: Color(0xFF4F4F4F),
                              size: 24,
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
                              color: Color(0xFF030303),
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
      bottomNavigationBar: Container(
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
              icon: Icon(PhosphorIcons.regular.house, size: 28),
              label: 'Basket',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.fill.basket, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.regular.user, size: 28),
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
      backgroundColor: MyColors.black100,
    );
  }
}
