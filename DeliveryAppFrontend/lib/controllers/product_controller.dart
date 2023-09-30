import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/controllers/cart_controller.dart';
import 'package:shopping_app/data/repos/product_repo.dart';
import 'package:shopping_app/models/product.dart';

import '../base/custom_snackbar.dart';
import '../models/product.dart';
import 'cart_controller.dart';

class ProductController extends GetxController {
  final ProductRepo productRepo;
  ProductController({required this.productRepo});

  late CartController _cart;
  // Latest products
  List<Product> _popularProductList=[];
  bool _isLoading = false;
  bool _isExit = false;
  //works with the add or remove button. after adding or removing it's set to zero again
  int _quantity = 0;

  int get quantity => _quantity<=1?0:_quantity;

  List<Product> get popularProductList => _popularProductList;
  bool get isLoading => _isLoading;
  bool get isExist=>_isExit;
  int get length =>_popularProductList.length;

  //add in the list if a certian product is added or not
  List<bool> _addOnActiveList = [];
  //certain products quantity
  List<int> _addOnQtyList = [];

  List<bool> get addOnActiveList => _addOnActiveList;
  List<int> get addOnQtyList => _addOnQtyList;

  //it will store the number of items in the memory. It stores for the item number for all the items in the shop
  int _certainItems=0;
  int get certainItems=>_certainItems+_quantity;

  Future<void> getRecommendedProductList(bool reload) async {
    if(_popularProductList == null || reload) {

      Response response = await productRepo.getRecommendedProductList();
      if (response.statusCode == 200) {
        _popularProductList = [];
        _popularProductList.addAll(ProductModel.fromJson(response.body).products);
        //_popularPageSize = ProductModel.fromJson(response.body).totalSize;

       // print("product id is  "+ProductModel.fromJson(response.body).products.toString());
        _isLoading = true;
        update();
      }else{
        showCustomSnackBar(response.statusText!);
      }

      } else {

      }
    }


    void addItem(Product product){
      _cart.addItem(product, _quantity, );
      _quantity=0;
      //save whatever the current _certainItems number is
      //_certainItems += _quantity;
      _certainItems = _cart.getQuantity(product);
      //it's important to set to zero. we do this so that aftr adding to cart, we start counting the added numbers
      //this would also stop resubmitting of the form without adding any in the cart.
      _quantity=0;
      update();
    }
    //controllers stays in the memory, we need to init some data, each time
    //visit a page or item
    void initData(Product product, int pageId, CartController cart){

        _quantity=0;
        _certainItems=0;
        _cart=cart;
        _isExit=_cart.isExistInCart(product);
        //if it exist in the cart then we get the existed item
        //in the cart. This is specially useful when you reload the app
        if(_isExit){
          _certainItems = _cart.getQuantity(product);
          //_quantity=_certainItems;
        }else{
          _certainItems=0;
        }
       // update();
    }



  void showBottomLoader() {
    _isLoading = true;
    update();
  }



  void setQuantity(bool isIncrement, Product product) {
    /*

    here _quantity either positive or negative returned to other functions
     */
    if (isIncrement) {
      _quantity = checkQuantity(_quantity+1);
    } else {
      //when we do remove things using the button
      //_quantity becomes negetive
      _quantity = checkQuantity(_quantity-1);
    }

    update();
  }

  int checkQuantity(int count){
    if((count+_certainItems)<0){

      Get.snackbar("Item count", "You can not reduce more",
      backgroundColor: AppColors.mainColor,
        colorText: Colors.white
      );
      if(_certainItems>0){
        _quantity = -_certainItems;
        return _quantity;
      }
      return 0;
    }else if((count+_certainItems)>100){
      Get.snackbar("Item count", "Not more than $count in the stock");
      return 100;
    }else{
      return count;
    }
  }

  }


  List<Product> _items = [

  ];

  List<Product> get items{
    return [..._items];
  }



  Product findProductById(int id){
    return _items.firstWhere((element) => element.id == id);
  }





