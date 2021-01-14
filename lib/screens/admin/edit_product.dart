import 'package:flutter/material.dart';
import 'package:hi/models/product_model.dart';
import 'package:hi/services/data_store.dart';
import 'package:hi/utilities/common.dart';
import 'package:hi/widgets/custom_textfield.dart';

class EditProduct extends StatelessWidget {
  static const id = 'edit-product';
  final _formKey = GlobalKey<FormState>();

  String _name, _description, _category, _imageLocation;
  double _price;

  final DataStore datastore = DataStore();
  @override
  Widget build(BuildContext context) {
    ProductModel product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        backgroundColor: mainColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          children: [
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              hint: 'Product Name',
              icon: Icons.edit,
              onClick: (val) => _name = val,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFormField(
              hint: 'Product Price',
              icon: Icons.edit,
              onClick: (val) => _price = double.tryParse(val),
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFormField(
              hint: 'Product Description',
              icon: Icons.edit,
              onClick: (val) => _description = val,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFormField(
              hint: 'Product Category',
              icon: Icons.edit,
              onClick: (val) => _category = val,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextFormField(
              hint: 'Product Location',
              icon: Icons.edit,
              onClick: (val) => _imageLocation = val,
            ),
            SizedBox(
              height: 20,
            ),
            // CustomTextFormField(hint: 'Name', icon: null),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                // _addProduct();
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  try {
                    datastore.editProduct(
                        ProductModel(
                            pCategory: _category,
                            pDescription: _description,
                            pLocation: _imageLocation,
                            pName: _name,
                            pPrice: _price),
                        product.productId);
                  } catch (e) {}
                }
              },
              child: Text('Add Product'),
              color: mainColor,
              padding: EdgeInsets.symmetric(horizontal: 50),
            ),
          ],
        ),
      ),
    );
  }
}
