import 'package:budget_basket/models/grocery_store.dart';
import 'package:budget_basket/util/my_colors.dart';
import 'package:budget_basket/util/my_logos.dart';
import 'package:flutter/material.dart';

class BasketItem extends StatefulWidget {
  final String itemName;
  final String? itemDescription;
  final GroceryStore itemStore;
  final double itemDistance;
  final double itemPrice;
  final double? itemSavings;
  final String? itemImgUrl;
  final bool isInCart;
  final void Function() onPressed;

  const BasketItem({
    super.key,
    required this.itemName,
    this.itemDescription,
    required this.itemStore,
    required this.itemDistance,
    required this.itemPrice,
    this.itemSavings,
    this.itemImgUrl,
    required this.isInCart,
    required this.onPressed,
  });

  @override
  State<BasketItem> createState() => _BasketItemState();
}

class _BasketItemState extends State<BasketItem> {
  bool active = false;

  void toggleActive() {
    setState(() {
      // Change the active state
      active = !active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TapRegion(
                onTapInside: (event) => toggleActive(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
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
                                  (widget.itemImgUrl != null)
                                      ? Container(
                                          width: 56,
                                          height: 56,
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: Image.network(
                                                      widget.itemImgUrl!)
                                                  .image,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  Expanded(
                                    child: Container(
                                      height: 56,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              widget.itemName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          (widget.itemDescription != null)
                                              ? SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    widget.itemDescription!,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 20,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 28,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image:
                                                          MyLogos.getLogoImage(
                                                                  widget
                                                                      .itemStore)
                                                              .image,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          widget.itemStore
                                              .toString()
                                              .split('.')
                                              .last,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFCCE6FF),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.itemDistance.toStringAsFixed(2)}mi',
                                          style: TextStyle(
                                            color: Color(0xFF030303),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: 1,
                      height: 76,
                      color: MyColors.black300,
                    ),
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '\$${widget.itemPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Color(0xFF25487B),
                              fontSize: 29,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          (widget.itemSavings != null)
                              ? Text(
                                  '\$${widget.itemSavings!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Color(0xFF5BB72B),
                                    fontSize: 19,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              (active) ? const SizedBox(height: 15) : SizedBox.shrink(),
              (active)
                  ? ElevatedButton(
                      onPressed: () {
                        toggleActive();
                        widget.onPressed();
                      },
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(double.infinity, 0)),
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(
                            (widget.isInCart) ? MyColors.red : MyColors.blue),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 10),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: Text(
                        (widget.isInCart) ? 'Remove' : 'Add to Basket',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
