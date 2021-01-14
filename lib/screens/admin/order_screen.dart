import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/models/order_model.dart';
import 'package:hi/screens/admin/order_details.dart';
import 'package:hi/services/data_store.dart';
import 'package:hi/utilities/common.dart';

class OrderScreen extends StatelessWidget {
  static const id = 'order-screen';
  final DataStore _store = DataStore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: mainColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'no orders yet',
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('loading...'),
                ],
              ),
            );
          }

          List<OrderModel> orders = [];
          for (var doc in snapshot.data.docs) {
            orders.add(
              OrderModel(
                id: doc.id,
                address: doc.get(kAddress),
                totalPrice: doc.get(totalPrice),
              ),
            );
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, OrderDetails.id, arguments: orders[index].id);
                  },
                                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .2,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
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
                            'Total Price = \$ ${orders[index].totalPrice}',
                            style: GoogleFonts.oxygen(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Address is ${orders[index].address}',
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
          );
        },
      ),
    );
  }
}
