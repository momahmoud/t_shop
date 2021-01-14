import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/models/product_model.dart';
import 'package:hi/services/data_store.dart';
import 'package:hi/utilities/common.dart';

class OrderDetails extends StatelessWidget {
  static const id = 'o-details';
  final DataStore _store = DataStore();
  @override
  Widget build(BuildContext context) {
    String orderId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        actions: [
          ButtonTheme(
            
            minWidth: 10,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                'Confirm',
              ),
            ),
          ),
          ButtonTheme(
            minWidth: 10,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                'Cancel',
              ),
            ),
          ),
        ],
        title: Text('Order Details'),
        backgroundColor: mainColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrderDetails(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('loading...'),
                ],
              ),
            );
          }

          List<ProductModel> products = [];
          for (var doc in snapshot.data.docs) {
            products.add(
              ProductModel(
                pName: doc.get(productName),
                pPrice: doc.get(productPrice),
                pCategory: doc.get(productCategory),
                qauntity: doc.get(productQuantity),
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(context, OrderDetails.id, arguments: products[index].id);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            height: MediaQuery.of(context).size.height * .3,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'order number $index',
                                  style: GoogleFonts.oxygen(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: mainColor),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Product Name: ${products[index].pName}',
                                  style: GoogleFonts.oxygen(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Price is ${products[index].pPrice}',
                                  style: GoogleFonts.oxygen(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Quantity is ${products[index].qauntity}',
                                  style: GoogleFonts.oxygen(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Category is ${products[index].pCategory}',
                                  style: GoogleFonts.oxygen(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
            ],
          );
        },
      ),
    );
  }
}
