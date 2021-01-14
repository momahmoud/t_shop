import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/models/product_model.dart';
import 'package:hi/screens/login_screen.dart';
import 'package:hi/screens/product_details.dart';
import 'package:hi/services/auth.dart';
import 'package:hi/services/data_store.dart';
import 'package:hi/utilities/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _store = DataStore();
  final _auth = Auth();
  int _tabBarIndex = 0;
  int _bottomNavigationBarIndex = 0;
  List<ProductModel> _products = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _bottomNavigationBarIndex,
              selectedItemColor: Colors.yellow,
              unselectedItemColor: Colors.grey,
              onTap: (index) async {
                if (index == 2) {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.clear();
                  await _auth.signOut();
                  Navigator.popAndPushNamed(context, LoginScreen.routeName);
                }
                setState(() {
                  _bottomNavigationBarIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  title: Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  title: Text('Account'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.exit_to_app,
                  ),
                  title: Text('logOut'),
                ),
              ],
            ),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              bottom: TabBar(
                indicatorColor: mainColor,
                onTap: (index) {
                  setState(() {
                    _tabBarIndex = index;
                  });
                },
                tabs: [
                  Text(
                    'Jackets',
                    style: GoogleFonts.oxygen(
                        color: _tabBarIndex == 0 ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: _tabBarIndex == 0 ? 16 : 14),
                  ),
                  Text(
                    'Trouser',
                    style: GoogleFonts.oxygen(
                        color: _tabBarIndex == 1 ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: _tabBarIndex == 1 ? 16 : 14),
                  ),
                  Text(
                    'T-shirts',
                    style: GoogleFonts.oxygen(
                        color: _tabBarIndex == 2 ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: _tabBarIndex == 2 ? 16 : 14),
                  ),
                  Text(
                    'Shoes',
                    style: GoogleFonts.oxygen(
                        color: _tabBarIndex == 3 ? Colors.black : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: _tabBarIndex == 3 ? 16 : 14),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                productsCategoryView(kJackets),
                productsCategoryView(kTrousers),
                productsCategoryView(kTshirts),
                productsCategoryView(kShoes),
              ],
            ),
          ),
        ),
        Material(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DISCOVER',
                    style: GoogleFonts.oxygenMono(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
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
        )
      ],
    );
  }

  Widget productsCategoryView(category) {
    return StreamBuilder<QuerySnapshot>(
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

          products.add(
            ProductModel(
              pCategory: data[productCategory],
              pDescription: data[productDescription],
              pLocation: data[productLocation],
              pName: data[productName],
              pPrice: double.parse(data[productPrice]),
              productId: doc.id,
            ),
          );
        }
        _products = [...products];
        products.clear();
        products = getProductByCat(category);

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
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ProductDetails.id,
                    arguments: products[index],
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
                                '\$ ${products[index].pPrice.toString()}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
    );
  }

  List<ProductModel> getProductByCat(String kJackets) {
    List<ProductModel> products = [];
    try {
      for (var product in _products) {
        if (product.pCategory == kJackets) {
          products.add(product);
        }
      }
    } on Error catch (e) {
      print(e);
    }

    return products;
  }
}
