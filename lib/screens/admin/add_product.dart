import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hi/models/product_model.dart';
import 'package:hi/services/data_store.dart';
import 'package:hi/utilities/common.dart';
import 'package:hi/widgets/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ignore: must_be_immutable
class AddProduct extends StatefulWidget {
  static const id = 'addProduct';

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String productId;
  String _name, _description, _category;

  double _price;

  File file;
  bool uploading = false;

  final DataStore datastore = DataStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Form(
          key: _formKey,
          child: Column(
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
              // CustomTextFormField(
              //   hint: 'Product Location',
              //   icon: Icons.edit,
              //   onClick: (val) => _imageLocation = val,
              // ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (file != null)
                    IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () => takeImage(context)),
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: file == null
                        ? IconButton(
                            icon: Icon(Icons.image),
                            onPressed: () => takeImage(context))
                        : Image.file(
                            file,
                          ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              // CustomTextFormField(hint: 'Name', icon: null),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  // ignore: unnecessary_statements
                  _addProduct();
                },
                child: Text('Add Product'),
                color: mainColor,
                padding: EdgeInsets.symmetric(horizontal: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        uploading = true;
      });
      String downloadUrl = await uploadImage(file);
      print(uploading);
      try {
        datastore.addProduct(
          ProductModel(
            productId: productId,
            pCategory: _category,
            pDescription: _description,
            pLocation: downloadUrl,
            pName: _name,
            pPrice: _price,
          ),
        );
        print('done');
        setState(() {
          uploading = false;
        });
      } catch (e) {
        print(e.message);
      }
    }
  }

  Future<String> uploadImage(imageFile) async {
    final StorageReference storage =
        FirebaseStorage.instance.ref().child("items");
    StorageUploadTask uploadTask =
        storage.child("product_$productId.jpg").putFile(imageFile);

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  takeImage(context) {
    return showDialog(
      context: context,
      builder: (con) {
        return SimpleDialog(
          title: Text(
            'Select Image',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                'Capture with camera',
              ),
              onPressed: () => captureImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text(
                'Select from gallery',
              ),
              onPressed: () => captureImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void captureImage(ImageSource source) async {
    Navigator.pop(context);
    final imageFile = await ImagePicker().getImage(
      source: source,
      maxHeight: 300,
      maxWidth: 300,
    );
    setState(() {
      if (imageFile != null) {
        file = File(imageFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void galleryImage() {}
}
