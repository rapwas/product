import 'package:flutter/material.dart';
import 'package:product/product.dart';
import 'package:product/api.dart';
import 'package:product/update.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}


class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];
  bool isLoaded = true;

  Future<void> getProductList() async {
  List<Product> futureProducts = await ProductService.fetchData();
  setState(() {
    products = futureProducts;
    isLoaded = false;
  });
}

  @override
  void initState() {
    super.initState();
    getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product"),
        backgroundColor: const Color.fromARGB(255, 243, 178, 255),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                getProductList();
              }),
        ],
      ),
      body: isLoaded ? const Center(child: Text('loading...')) : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          print(product);
          print(index);
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(product.name,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.desc),
                  Text("${product.price} ฿",
                      style: const TextStyle(color: Colors.green)),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color.fromARGB(255, 88, 180, 255)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateProductPage(product: product),
                        ),
                      ).then((result) {
                              if (result == true) {
                                getProductList();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Product updated successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            });
                    },
                  ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: Text(
                                    'Are you sure you want to delete "${product.name}"?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                      ProductService.deleteProduct(product.id)
                                          .then((_) {
                                        getProductList();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Product deleted successfully!'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      });
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateProductPage(),
            ),
          ).then((result) {
            if (result == true) {
              getProductList();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product added successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 243, 178, 255),
      ),
    );
  }
}
