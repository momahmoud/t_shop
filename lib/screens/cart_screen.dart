import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/models/product_model.dart';
import 'package:hi/providers/cart_item.dart';
import 'package:hi/screens/product_details.dart';
import 'package:hi/services/data_store.dart';
import 'package:hi/utilities/common.dart';
import 'package:provider/provider.dart';

import 'admin/manage_products.dart';

class CartScreen extends StatefulWidget {
  static const id = 'cart-screen';
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    List<ProductModel> products = Provider.of<CartItem>(context).products;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            if (products.isEmpty) {
              return Container(
                height: height - (height / 15) - appBarHeight - statusBarHeight,
                child: Center(
                  child: Text(
                    'your cart is empty!',
                    style: GoogleFonts.oxygen(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              );
            }
            return Container(
              height: height - (height / 15) - appBarHeight - statusBarHeight,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTapUp: (details) {
                      showCustomMenu(details, context, products[index]);
                    },
                    child: Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Container(
                        height: height * .14,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: height * .14 / 2,
                              backgroundImage:
                                  NetworkImage(products[index].pLocation),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[index].pName,
                                        style: GoogleFonts.oxygen(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '\$ ${products[index].pPrice}',
                                        style: GoogleFonts.oxygen(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            '${products[index].qauntity} x',
                                            style: GoogleFonts.oxygen(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .26,
                                          ),
                                          Text(
                                            'Total: ',
                                            style: GoogleFonts.oxygen(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '\$ ${products[index].qauntity * products[index].pPrice}',
                                            style: GoogleFonts.oxygen(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          Builder(
            builder: (context) => ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              )),
              minWidth: width,
              height: height / 15,
              child: RaisedButton(
                onPressed: () {
                  showCustomDialog(products, context);
                },
                color: mainColor,
                child: Text(
                  'order now'.toUpperCase(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCustomMenu(details, context, product) async {
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
            Navigator.pop(context);
            Provider.of<CartItem>(context, listen: false)
                .deleteProduct(product);
            Navigator.pushNamed(context, ProductDetails.id, arguments: product);
          },
          child: Text('Edit'),
        ),
        MyPopupMenuItem(
          onClick: () {
            Navigator.pop(context);
            Provider.of<CartItem>(context, listen: false)
                .deleteProduct(product);
          },
          child: Text('Delete'),
        ),
      ],
    );
  }

  void showCustomDialog(List<ProductModel> products, context) async {
    var price = getTotalPrice(products);
    var address;
    AlertDialog alertDialog = AlertDialog(
      actions: [
        FlatButton(
          onPressed: () {
            try {
              DataStore _store = DataStore();
              _store.storeOrders(
                {totalPrice: price, kAddress: address},
                products,
              );

              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('order added successfully'),
                ),
              );
              Navigator.pop(context);
            } catch (e) {
              print(e.message);
            }
          },
          child: Text(
            'Confirm',
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
          ),
        ),
      ],
      title: Text('Total Price = \$ $price'),
      content: TextField(
        onChanged: (value) {
          address = value;
        },
        decoration: InputDecoration(
          hintText: 'Enter Your Address',
        ),
      ),
    );
    await showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  getTotalPrice(List<ProductModel> products) {
    double price = 0.0;
    for (var product in products) {
      price += product.qauntity * product.pPrice;
    }
    return price;
  }
}
