import 'package:get/get_connect/http/src/response/response.dart';

import '../../base/custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../../routes/route_helper.dart';
class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();

      Get.offAllNamed(RouteHelper.getSignInRoute());
    }else {
      showCustomSnackBar(response.statusText!);
    }
  }
}