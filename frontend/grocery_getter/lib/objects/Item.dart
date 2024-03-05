class Item {
  String name;
  double price;
  double? savings;
  bool isChecked = false;

  Item({required this.name, required this.price, this.savings});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        name: json['name'],
        price: json['price'].toDouble(),
        savings: json['savings'].toDouble());
  }
}
