
import 'package:flutter/material.dart';
import 'package:product/api.dart';
import 'package:product/product.dart';
import 'package:product/product_page.dart';

class UpdateProductPage extends StatefulWidget {
  final Product? product;
  const UpdateProductPage({super.key, this.product});
  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      nameController.text = widget.product!.name;
      descriptionController.text = widget.product!.desc;
      priceController.text = widget.product!.price.toString();
    }
  }
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
          title: Text(widget.product == null ? "Add Product" : "Edit Product")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Product Name"),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Price"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.product == null ? ProductService.createProduct(nameController.text.trim() , descriptionController.text.trim() , double.tryParse(priceController.text) ?? 0.0) : ProductService.updateProduct(Product(widget.product!.id, nameController.text.trim() , descriptionController.text.trim() , double.tryParse(priceController.text) ?? 0.0));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(
                  widget.product == null ? "Add Product" : "Update Product"),
            ),
          ],
        ),
      ),
    );
  }
}