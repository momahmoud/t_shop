import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/models/product_model.dart';
import 'package:hi/providers/cart_item.dart';
import 'package:hi/utilities/common.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

class ProductDetails extends StatefulWidget {
  static const id = 'product-details';
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _qauntity = 1;
  @override
  Widget build(BuildContext context) {
    ProductModel product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .6,
              width: MediaQuery.of(context).size.width,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                  product.pLocation,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Container(
                height: MediaQuery.of(context).size.height * .1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Icon(Icons.arrow_back_ios),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          CartScreen.id,
                        );
                      },
                      child: Icon(
                        Icons.shopping_cart,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                // color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.pName,
                          style: GoogleFonts.oxygen(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '\$ ${product.pPrice}',
                          style: GoogleFonts.oxygen(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      product.pDescription,
                      style: GoogleFonts.oxygen(
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Material(
                            color: mainColor,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _qauntity++;
                                });
                              },
                              child: SizedBox(
                                child: Icon(Icons.add),
                                height: 28,
                                width: 28,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            _qauntity.toString(),
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                        ClipOval(
                          child: Material(
                            color: mainColor,
                            child: GestureDetector(
                              onTap: () {
                                if (_qauntity > 1) {
                                  setState(() {
                                    _qauntity--;
                                  });
                                }
                              },
                              child: SizedBox(
                                child: Icon(Icons.remove),
                                height: 28,
                                width: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 12,
                child: Builder(
                  builder: (context) => RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )),
                    color: mainColor,
                    onPressed: () {
                      addToCart(context, product);
                    },
                    child: Text(
                      'Add to Cart'.toUpperCase(),
                      style: GoogleFonts.oxygen(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToCart(context, product) {
    CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    bool exist = false;
    product.qauntity = _qauntity;
    var productsInCart = cartItem.products;
    for (var productInCart in productsInCart) {
      if (productInCart.productId == product.productId) {
        exist = true;
      }
    }
    if (exist) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('you\'ve added this item before'),
        ),
      );
    } else {
      cartItem.addProduct(product);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('added to cart successfully!'),
        ),
      );
    }
  }
}
