import 'package:shopping_app/base/custom_snackbar.dart';

import '../data/api/api_checker.dart';
import '../data/repos/splash_repo.dart';
import 'package:get/get.dart';

import '../models/config_model.dart';
class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({required this.splashRepo});

  ConfigModel? _configModel;
  DateTime _currentTime = DateTime.now();
  bool _firstTimeConnectionCheck = true;

  ConfigModel? get configModel => _configModel;
  DateTime get currentTime => DateTime.now();
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  Future<bool> getConfigData() async {
    Response response = await splashRepo.getConfigData();
    bool _isSuccess = false;
    if(response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(response.body);
      _isSuccess = true;
    }else {
      //ApiChecker.checkApi();
      showCustomSnackBar(response.statusText.toString());
      print("My code is "+response.statusText.toString());
      _isSuccess = false;
    }
    update();
    return _isSuccess;
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }



  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  bool? showIntro() {
    return splashRepo.showIntro();
  }
}
