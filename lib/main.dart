import 'package:flutter/material.dart';
import 'package:hi/providers/admin_mode.dart';
import 'package:hi/providers/cart_item.dart';
import 'package:hi/screens/admin/add_product.dart';
import 'package:hi/screens/admin/admin_screen.dart';
import 'package:hi/screens/admin/edit_product.dart';
import 'package:hi/screens/admin/manage_products.dart';
import 'package:hi/screens/admin/order_details.dart';
import 'package:hi/screens/admin/order_screen.dart';
import 'package:hi/screens/cart_screen.dart';
import 'package:hi/screens/home_screen.dart';
import 'package:hi/screens/login_screen.dart';
import 'package:hi/screens/product_details.dart';
import 'package:hi/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hi/utilities/common.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/modal_hud.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp();

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('Loading...'),
              ),
            ),
          );
        } else {
          isUserLoggedIn = snapshot.data.getBool(kStayLogin) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModalHud>(
                create: (context) => ModalHud(),
              ),
              ChangeNotifierProvider<AdminMode>(
                create: (context) => AdminMode(),
              ),
              ChangeNotifierProvider<CartItem>(
                create: (context) => CartItem(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              // initialRoute: LoginScreen.routeName,
              home: App(isLogin: isUserLoggedIn,),
              routes: {
                LoginScreen.routeName: (context) => LoginScreen(),
                SignUpScreen.routeName: (context) => SignUpScreen(),
                HomeScreen.id: (context) => HomeScreen(),
                AdminScreen.id: (context) => AdminScreen(),
                AddProduct.id: (context) => AddProduct(),
                ManageProducts.id: (context) => ManageProducts(),
                EditProduct.id: (context) => EditProduct(),
                ProductDetails.id: (context) => ProductDetails(),
                CartScreen.id: (context) => CartScreen(),
                OrderScreen.id: (context) => OrderScreen(),
                OrderDetails.id: (context) => OrderDetails(),
              },
            ),
          );
        }
      },
    );
  }
}

class App extends StatelessWidget {
  final bool isLogin;
  App({
    this.isLogin
  });
  // Create the initilization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('error')));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return isLogin ? HomeScreen() : LoginScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
