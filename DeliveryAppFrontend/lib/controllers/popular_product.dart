import 'package:get/get.dart';
import 'package:shopping_app/base/custom_snackbar.dart';
import 'package:shopping_app/data/repos/popular_product_repo.dart';
import 'package:shopping_app/models/product.dart';

class PopularProduct extends GetxController{
  final PopularProductRepo popularProductRepo;
   PopularProduct( {required this.popularProductRepo});

  late List<Product> _popularProductList=[];
  bool _isLoading = false;
  bool _isExit = false;
  //works with the add or remove button. after adding or removing it's set to zero again
  int _quantity = 0;

  int get quantity => _quantity<=1?0:_quantity;

  List<Product> get popularProductList => _popularProductList;
  bool get isLoading => _isLoading;
  bool get isExist=>_isExit;
  int get length =>_popularProductList.length;


  Future<void> getPopularProductList(bool reload) async {
    if(_popularProductList == null || reload) {

      Response response = await popularProductRepo.getPopularProductList();
      if (response.statusCode == 200) {
        _popularProductList = [];
        _popularProductList.addAll(ProductModel.fromJson(response.body).products);
        _isLoading = false;
        update();
      }else{
        showCustomSnackBar(response.statusText!);
      }
    } else {

    }
  }
}