import 'dart:convert';

import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/repos/search_product_repo.dart';
import '../data/repos/search_product_repo.dart';
import '../models/product.dart';
class SearchProductController extends GetxController implements GetxService {
  final SearchProductRepo searchProductRepo;
  SearchProductController({required this.searchProductRepo});

  List<Product> _searchProductList=[];
  List<Product> _allProductList=[];

  String _searchText = '';
  String _prodResultText = '';
  double _lowerValue = 0;
  double _upperValue = 0;
  List<String> _historyList = [];
  bool _isSearchMode = true;
  List<String> _sortList = ['ascending'.tr, 'descending'.tr];
  int _sortIndex = -1;
  int _rating = -1;
  bool _isRestaurant = false;
  bool _isAvailableFoods = false;
  bool _isDiscountedFoods = false;

  List<Product>? get searchProductList => _searchProductList;
  List<Product>? get allProductList => _allProductList;

  String get searchText => _searchText;
  double get lowerValue => _lowerValue;
  double get upperValue => _upperValue;
  bool get isSearchMode => _isSearchMode;
  List<String> get historyList => _historyList;
  List<String> get sortList => _sortList;
  int get sortIndex => _sortIndex;
  int get rating => _rating;
  bool get isAvailableFoods => _isAvailableFoods;
  bool get isDiscountedFoods => _isDiscountedFoods;

  void toggleAvailableFoods() {
    _isAvailableFoods = !_isAvailableFoods;
    update();
  }

  void toggleDiscountedFoods() {
    _isDiscountedFoods = !_isDiscountedFoods;
    update();
  }

  void setRestaurant(bool isRestaurant) {
    _isRestaurant = isRestaurant;
    update();
  }

  void setSearchMode(bool isSearchMode) {
    _isSearchMode = isSearchMode;
    if(isSearchMode) {
      _searchText = '';
      _prodResultText = '';
      _allProductList = [];
      _searchProductList = [];
      _sortIndex = -1;
      _isDiscountedFoods = false;
      _isAvailableFoods = false;
      _rating = -1;
      _upperValue = 0;
      _lowerValue = 0;
    }
    update();
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    update();
  }



  void setSearchText(String text) {
    _searchText = text;
    update();
  }



  void searchData(String query) async {
    if( (!_isRestaurant && query.isNotEmpty && query != _prodResultText)) {
      _searchText = query;


        _searchProductList = [];
        _allProductList = [];


      _isSearchMode = false;


      update();

      Response response = await searchProductRepo.getSearchData(query);
      if (response.statusCode == 200) {


            _prodResultText = query;
            _searchProductList = [];
           _allProductList = [];
            _searchProductList.addAll(ProductModel.fromJson(response.body).products);
            _allProductList.addAll(ProductModel.fromJson(response.body).products);

      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }
  /*
  void getHistoryList() {
    _searchText = '';
    _historyList = [];
    _historyList.addAll(searchRepo.getSearchAddress());
  }

  void removeHistory(int index) {
    _historyList.removeAt(index);
    searchRepo.saveSearchHistory(_historyList);
    update();
  }*/
/*
  void clearSearchAddress() async {
    searchRepo.clearSearchHistory();
    _historyList = [];
    update();
  } */

  void setRating(int rate) {
    _rating = rate;
    update();
  }

  void setSortIndex(int index) {
    _sortIndex = index;
    update();
  }

  void resetFilter() {
    _rating = -1;
    _upperValue = 0;
    _lowerValue = 0;
    _isAvailableFoods = false;
    _isDiscountedFoods = false;
    _sortIndex = -1;
    update();
  }

}