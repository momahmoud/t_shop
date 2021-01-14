import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hi/models/product_model.dart';
import 'package:hi/utilities/common.dart';

class DataStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addProduct(ProductModel product) {
    _firestore.collection(productCollection).add({
      productName: product.pName,
      productCategory: product.pCategory,
      productDescription: product.pDescription,
      productPrice: product.pPrice,
      productLocation: product.pLocation,
    });
  }

  Stream<QuerySnapshot> loadProducts() {
    return _firestore.collection(productCollection).snapshots();
    // List<ProductModel> products = [];
    // await for (var snapshot
    //     in _firestore.collection(productCollection).snapshots()) {
    //   for (var doc in snapshot.docs) {
    //     var data = doc.data();
    //     products.add(ProductModel(
    //       pCategory: data[productCategory],
    //       pDescription: data[productDescription],
    //       pLocation: data[productLocation],
    //       pName: data[productName],
    //       pPrice: data[productPrice],
    //     ));
    //   }
    // }
    // return products;
  }

  deleteProduct(id) {
    _firestore.collection(productCollection).doc(id).delete();
  }

  editProduct(data, id) {
    _firestore.collection(productCollection).doc(id).update(data);
  }

  storeOrders(data, List<ProductModel> products) {
    var documentRef = _firestore.collection(orderCollection).doc();
    documentRef.set(data);
    for (var product in products) {
      documentRef.collection(orderDetails).doc().set({
        productName: product.pName,
        productPrice: product.pPrice,
        productQuantity: product.qauntity,
        productLocation: product.pLocation,
        productCategory: product.pCategory,
      });
    }
  }

  Stream<QuerySnapshot> loadOrders() {
    return _firestore.collection(orderCollection).snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(id) {
    return _firestore
        .collection(orderCollection)
        .doc(id)
        .collection(orderDetails)
        .snapshots();
  }
}
