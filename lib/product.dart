class Product {
  String id;
  String name;
  String desc;
  double price;

  Product(this.id, this.name,this.desc,this.price);

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        desc = json['description'],
        price = double.parse(json['price'].toString());


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': desc,
      'price': price,
    };
  }
}
