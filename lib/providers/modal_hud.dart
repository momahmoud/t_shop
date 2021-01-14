import 'package:flutter/cupertino.dart';

class ModalHud with ChangeNotifier{
  bool isLoading = false;

  changeIsLoading(bool value){
    isLoading = value;
    notifyListeners();
  }
}