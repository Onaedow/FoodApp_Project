import 'dart:core';

import 'package:get/get.dart';

import 'package:shopping_app/data/repos/cart_repo.dart';
import 'package:shopping_app/models/cart_item.dart';
import 'package:shopping_app/models/product.dart';

class CartController extends GetxController {
  final CartRepo cartRepo;
  CartController({required this.cartRepo, productRepo});

   Map<int, CartItem> _items = {};
   //late Map<int, CartItem> savedItems={};

   /*
   Save the storage info to the below list
    */
    List<CartItem> storageItems=[];
    // set here from sharedPreference when started the app
   set setCart(List<CartItem> items){
    // storageItems = items;
     for(int i=0; i<storageItems.length; i++){
       //print(storageItems[i].quantity);
       _items.putIfAbsent(
         storageItems[i].product.id,
           /*
           made code simpler.
            */
           ()=>items[i]

       );
     }
   }

  Map<int, CartItem> get items {
     return _items;
  }

  set setItems(Map<int, CartItem> setItems) {
     _items={};
     _items=setItems;
  }

  List<CartItem> _cartList=[];
  void clearCartList() {
    _cartList = [];
    cartRepo.addToCartList(_cartList);
    update();
  }

  void addToCarts(CartItem cart){
    _cartList.add(cart);
    Get.find<CartRepo>().addToCartList(_cartList);
  }
  /*
  Get all the info from the storage
   */
  List<CartItem> getCartsData(){
    //retreive all the info the storage and set it to
    //_items through setCart
   setCart= Get.find<CartRepo>().getCartList();

   return storageItems;
  }
  //map converts to list
  //We need to convert this to list since we want to
  //send the cart info the sharedpreferecen.
  //Shared preference only works with list
  //this list also has the latest update throughout the app
  List<CartItem> get getCarts{
   return items.entries.map((e) {
     return e.value;
   }).toList();

  }

  int _certainItems=0;
  int get certainItems=>_certainItems;
  //get totalAmount=>_totalAmount;

  int get itemCount{
      // return  _items?.length?? 0;
  return _items.length;

  }
  double get totalAmount{
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  int get totalItems{
    var total=0;
    _items.forEach((key, value) {
      total +=value.quantity;

    });
    return total;
  }

  void addItem(Product product, int quantity) {
    int total=0;
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (existingCartItem){
         total=   existingCartItem.quantity+quantity;
            return CartItem(
              id: existingCartItem.id.toString(),
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + quantity,
              price: existingCartItem.price,
              img:product.img,
              product: product,
              time:DateTime.now().toString());
            },
              );
      /*
      with this we are making sure, we are removing all
      items that has zero quantity in the cart. This way cart
      would automatially get updated
       */
            if(total<=0){
              _items.remove(product.id);
             // print("removed");
            }else{
             // print("not remove");
            }
      update();

    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: product.id.toString(),
          title: product.title,
          price: product.price,
          quantity: quantity,
          img:product.img,
          product: product,
            time:DateTime.now().toString()
        ),
      );
    }
    // this makes sure that we are saving in the sharedpreference every time user clicks to add to cart button
    cartRepo.addToCartList(getCarts);
    update();
  }

  void addToCartList(){
    cartRepo.addToCartList(getCarts);

  }

  void addToHistory(){
    cartRepo.addToCartHistoryList();
    /*
    _items should be set to empty after adding. So we created clear method. It sets it to empty
     */
    clear();
  }

  List<CartItem> getCartHistory(){
   return cartRepo.getCartHistoryList();
  }

  bool isExistInCart(Product product){

    if(_items.containsKey(product.id)){
     _items.forEach((key, value) {
       print(key.toString());
       if(key==product.id){
        //value.quantity.toString()
         value.isExist=true;
       }
     });
      return true;
    }else{
      return false;
    }
  }

  int getQuantity(Product product){
    if(_items.containsKey(product.id)){
      _items.forEach((key, value) {
       // print(key.toString());
        if(key==product.id){
          //value.quantity.toString()
          _certainItems=int.parse(value.quantity.toString());
        }
      });
      return _certainItems;
    }else{
      return 0;
    }
  }

  void removeItem(int productId){
    _items.remove(productId);
    update();
  }

  void clear(){
    _items = {};
    update();
  }

  void removeCartSharedPreference(){
    cartRepo.removeCartSharedPreference();
  }
}
