import 'package:flutter/cupertino.dart';
import 'package:flutter_kickstart/model/product_in_category_model.dart';

class ProductProvider with ChangeNotifier {
  ProductCategory productCategory;
  bool noMessage;

  void setProductCategory(ProductCategory productCategory) {
    this.productCategory = productCategory;
    notifyListeners();
  }

  void setMessage(bool noMessage) {
    this.noMessage = noMessage;
    notifyListeners();
  }

  ProductCategory getProductCategory() {
    return productCategory;
  }

  bool getMessage(){
    return noMessage;
  }

  void clearProductCategory() {
    productCategory = null;
    notifyListeners();
  }

  void clearMessage(){
    noMessage = null;
    notifyListeners();
  }
}