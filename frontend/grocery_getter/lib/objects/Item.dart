class Item {
  String name;
  double price;

  Item({
    required this.name,
    required this.price
  });

  factory Item.fromJSON(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      price: json['price']
    );
  }
}