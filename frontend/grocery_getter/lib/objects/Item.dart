class Item {
  String name;
  double price;
  bool isChecked = false;

  Item({required this.name, required this.price});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(name: json['name'], price: json['price']);
  }
}
