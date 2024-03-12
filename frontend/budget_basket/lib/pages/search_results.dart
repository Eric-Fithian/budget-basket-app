import 'package:budget_basket/components/basket_item.dart';
import 'package:budget_basket/models/grocery_store.dart';
import 'package:budget_basket/models/item.dart';
import 'package:budget_basket/providers/shopping_cart_provider.dart';
import 'package:budget_basket/util/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class SearchResultsPage extends StatefulWidget {
  final List<Item> items;
  final String searchTerm;

  const SearchResultsPage({
    super.key,
    required this.searchTerm,
    required this.items,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          'Search Results for ...',
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
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: BasketItem(
                          key: ValueKey(widget.items[index]),
                          itemName: widget.items[index].itemName,
                          itemDescription: widget.items[index].itemDescription,
                          itemStore: widget.items[index].itemStore,
                          itemDistance: widget.items[index].itemDistance,
                          itemPrice: widget.items[index].itemPrice,
                          itemSavings: widget.items[index].itemSavings,
                          itemImgUrl: widget.items[index].itemImgUrl,
                          isInCart: false,
                          onPressed: () {
                            Provider.of<ShoppingCartProvider>(
                              context,
                              listen: false,
                            ).addItem(widget.items[index]);
                            Navigator.pop(context);
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
      ),
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
