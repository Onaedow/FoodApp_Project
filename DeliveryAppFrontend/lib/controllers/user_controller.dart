
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/data/repos/user_repo.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/models/response_model.dart';
import 'package:get/get.dart';
import 'package:shopping_app/models/user_info_model.dart';
import 'package:http/http.dart' as http;
class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({required this.userRepo});
   PickedFile? _pickedFile;

  PickedFile? get pickedFile => _pickedFile;

  bool get isLoading => _isLoading;

  bool _isLoading = false;
  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  void pickImage() async {
    final picker = ImagePicker();
    _pickedFile = (await picker.getImage(source: ImageSource.gallery))!;

    update();
  }

  void initData() {
    _pickedFile = null;
  }

    Future<ResponseModel> getUserInfo() async {
      ResponseModel _responseModel;
      Response response = await userRepo.getUserInfo();
      if (response.statusCode == 200) {
        _userInfoModel = UserInfoModel.fromJson(response.body);

        _responseModel = ResponseModel(true, 'successful');
       // _isLoading=true;
      } else {
        _responseModel = ResponseModel(false, response.statusText!);
      }

      update();
      return _responseModel;
    }


  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    ResponseModel _responseModel;

    http.StreamedResponse response = await userRepo.updateProfile(updateUserModel, _pickedFile, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _userInfoModel = updateUserModel;
      _responseModel = ResponseModel(true, message);

     // _pickedFile = null;
      await getUserInfo();
      print(message);
    } else {
      _responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    update();

    return _responseModel;
  }


}