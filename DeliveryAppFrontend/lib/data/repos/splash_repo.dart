import 'package:shared_preferences/shared_preferences.dart';

import '../../uitls/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class SplashRepo {
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> getConfigData() async {
    Response _response = await apiClient.getData(AppConstants.CONFIG_URI);
    return _response;
  }

  Future<bool> initSharedData() {

    if(!sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      sharedPreferences.setStringList(AppConstants.CART_LIST, []);
    }
    if(!sharedPreferences.containsKey(AppConstants.INTRO)) {
      sharedPreferences.setBool(AppConstants.INTRO, true);
    }
    return Future.value(true);
  }

  bool? showIntro() {
    return sharedPreferences.getBool(AppConstants.INTRO);
  }

}