import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/screens/admin/add_product.dart';
import 'package:hi/screens/admin/manage_products.dart';
import 'package:hi/screens/admin/order_screen.dart';
import 'package:hi/utilities/common.dart';

class AdminScreen extends StatelessWidget {
  static const id = 'adminScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                _buildCard(Colors.orange, 'Add Product', () {
                  Navigator.of(context).pushNamed(AddProduct.id);
                }),
                _buildCard(Colors.lightBlue, 'Manage Product', () {
                  Navigator.of(context).pushNamed(ManageProducts.id);
                }),
              ],
            ),
            Row(
              children: [
                _buildCard(Colors.cyan, 'View Orders', () {
                  Navigator.of(context).pushNamed(OrderScreen.id);
                }),
                _buildCard(Colors.green, 'Other', () {}),
              ],
            ),
            // Row(
            //   children: [
            //     _buildCard(Colors.teal, '', () {}),
            //     _buildCard(Colors.amber, '', () {}),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Color color, String title, Function onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: color,
          child: Container(
            height: 150,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.oxygen(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
