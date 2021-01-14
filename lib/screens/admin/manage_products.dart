import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hi/models/product_model.dart';
import 'package:hi/services/data_store.dart';
import 'package:hi/utilities/common.dart';

import 'edit_product.dart';

class ManageProducts extends StatefulWidget {
  static const id = 'manage-products';
  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  final _store = DataStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Edit Product'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('no products yet'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Loading...'), CircularProgressIndicator()],
              ),
            );
          }
          List<ProductModel> products = [];
          for (var doc in snapshot.data.docs) {
            var data = doc.data();
            products.add(ProductModel(
              pCategory: data[productCategory],
              pDescription: data[productDescription],
              pLocation: data[productLocation],
              pName: data[productName],
              pPrice: double.parse(data[productPrice]),
              productId: doc.id,
            ));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: .75),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: GestureDetector(
                  onTapUp: (details) {
                    double dx = details.globalPosition.dx;
                    double dy = details.globalPosition.dy;
                    double dx2 = MediaQuery.of(context).size.width - dx;
                    double dy2 = MediaQuery.of(context).size.width - dy;
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                      items: [
                        MyPopupMenuItem(
                          onClick: () {
                            print('object');
                            Navigator.pushNamed(context, EditProduct.id,
                                arguments: products[index]);
                            //  Navigator.pop(context);
                          },
                          child: Text('Edit'),
                        ),
                        MyPopupMenuItem(
                          onClick: () {
                            _store.deleteProduct(products[index].productId);
                            Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(products[index].pLocation),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Opacity(
                          opacity: .5,
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  products[index].pName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '\$ ${products[index].pPrice}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MyPopupMenuItem<T> extends PopupMenuItem<T> {
  final Function onClick;
  final Widget child;
  MyPopupMenuItem({@required this.child, @required this.onClick})
      : super(child: child);

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
    return MyPopupMenuItemState();
  }
}

class MyPopupMenuItemState<T, PopupMenuItem>
    extends PopupMenuItemState<T, MyPopupMenuItem<T>> {
  @override
  void handleTap() {
    widget.onClick();
  }
}
