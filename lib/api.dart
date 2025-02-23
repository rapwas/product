import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product/product.dart';

class ProductService{

  static const String API_URL = "http://10.0.2.2:3000/products";


  static Future<List<Product>> fetchData() async {
    try {
      var response = await http.get(Uri.parse(API_URL));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      return List.empty();
    }
  }

  static Future<bool> createProduct(String name,String desc, double price) async {
    try {
      var response = await http.post(
          Uri.parse(API_URL),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "name": name,
            "description": desc,
            "price": price
          }));
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<bool> updateProduct(Product product) async {
    try {
      var response = await http.put(
          Uri.parse("$API_URL/${product.id}"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "name": product.name,
            "description": product.desc,
            "price": product.price
          }));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  static Future<bool> deleteProduct(String id) async {
    try {
      var response = await http
          .delete(Uri.parse("$API_URL/$id"));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to delete products");
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}