import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../uitls/app_constants.dart';
import '../api/api_client.dart';

class SearchProductRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SearchProductRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getSearchData(String query) async {
    print('${AppConstants.BASE_URL}${AppConstants.SEARCH_URI}?name=$query');

    return await apiClient.getData('${AppConstants.SEARCH_URI}?name=$query');
  }

}