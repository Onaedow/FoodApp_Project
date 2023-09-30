import 'package:shopping_app/data/api/api_client.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/uitls/app_constants.dart';
import 'package:get/get.dart';

class PopularProductRepo extends GetxService {
  final ApiClient apiClient;
  PopularProductRepo({required this.apiClient});

  Future<Response> getPopularProductList() async {
    return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URI);
  }
}