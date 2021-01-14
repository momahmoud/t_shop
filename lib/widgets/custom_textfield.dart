
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function onClick;

  CustomTextFormField({
    @required this.hint,
    @required this.icon,
    this.onClick,
  });

  String _errorMessage(String str){
    switch (hint) {
      case 'Email': return 'Email is empty';
      case 'Name': return 'Name is empty';
      case 'Password': return 'Name is empty';
      case 'Product Name': return 'Product Name is empty';
      case 'Product Price': return 'Product Price is empty';
      case 'Product Description': return 'Product Description is empty';
      case 'Product Category': return 'Product Category is empty';
      case 'Product Location': return 'Product Location is empty';
      default: return 'error';
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // ignore: missing_return
      validator: (value){
        if(value.isEmpty){
          return _errorMessage(hint);
        }
      },
      onSaved: onClick,
      obscureText: hint == 'Password' ?? true,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: GoogleFonts.ubuntuMono(
          fontWeight: FontWeight.bold
        ),
        prefixIcon: Icon(icon),
        contentPadding: EdgeInsets.all(15),
        fillColor: Colors.white70,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.red),
        ),
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
