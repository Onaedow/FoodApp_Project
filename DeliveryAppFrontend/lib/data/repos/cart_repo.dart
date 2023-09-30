import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/models/cart_item.dart';

import '../../models/cart_item.dart';

class CartRepo{
  final SharedPreferences sharedPreferences;
  CartRepo({ required this.sharedPreferences});
  List<String> cart=[];
  List<String> cartHistory = [];
  List<CartItem> getCartList() {
    sharedPreferences.remove("Cart-list");
    sharedPreferences.remove("Cart-list-list");
    List<String> carts = [];
    if(sharedPreferences.containsKey("Cart-list")) {
      carts = sharedPreferences.getStringList("Cart-list")!;
    }
    List<CartItem> cartList = [];

    carts.forEach((cart) => cartList.add(CartItem.fromJson(jsonDecode(cart))) );
    return cartList;
  }
  void addToCartList(List<CartItem> cartProductList) {
    String time = DateTime.now().toString();
    cart = [];
    cartProductList.forEach((cartModel) {
      /*
      adding time help us to make history of shopping cart.
      based on this we can find the items that were bought at
      one time. This time is unique for every complete order
       */
      cartModel.time=time;
     return cart.add(jsonEncode(cartModel));
    });

    sharedPreferences.setStringList("Cart-list", cart);
  }

  void addToCartHistoryList() {

    for(int i=0; i<cart.length; i++){
      cartHistory.add(cart[i].replaceAll("\\", ""));
    }
    sharedPreferences.setStringList("Cart-list-list", cartHistory);
    //set cart to zero
    cart=[];
    sharedPreferences.remove("Cart-list");

  }

  List<CartItem> getCartHistoryList() {
    if(sharedPreferences.containsKey("Cart-list-list")){

      cartHistory = sharedPreferences.getStringList("Cart-list-list")!;
    }else{
      print("...............................nothing.........");
    }
    List<CartItem> cartList = [];
    /*
    We always need to convert the map or json to object or model
     */
    cartHistory.forEach((cart) => cartList.add(CartItem.fromJson(jsonDecode(cart))) );
    return cartList;
  }

  void removeCartSharedPreference(){
    sharedPreferences.remove("Cart-list");
    /*
    bug fix
     */
    sharedPreferences.remove("Cart-list-list");
  }
}