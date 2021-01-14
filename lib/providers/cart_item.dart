import 'package:flutter/cupertino.dart';
import 'package:hi/models/product_model.dart';

class CartItem extends ChangeNotifier {
  List<ProductModel> products = [];

  
  addProduct(ProductModel product) {
    products.add(product);
    notifyListeners();
  }

  deleteProduct(ProductModel product){
    products.remove(product);
    notifyListeners();
  }
}
