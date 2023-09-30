import 'package:shopping_app/data/repos/auth_repo.dart';
import 'package:get/get.dart';
import 'package:shopping_app/models/response_model.dart';
import 'package:shopping_app/models/signup_body.dart';
import 'package:shopping_app/uitls/app_constants.dart';
class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool _notification = true;
  bool _acceptTerms = true;

  bool get isLoading => _isLoading;

  bool get notification => _notification;

  bool get acceptTerms => _acceptTerms;

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {

        authRepo.saveUserToken(response.body["token"]);
        //await authRepo.updateToken();

      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.body["errors"][0]["message"]!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verification(VerificationBody verificationBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.send_verification(verificationBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      print(response.body["data"]);
      responseModel = ResponseModel(true, response.body["data"]);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }


  Future<ResponseModel> login(String phone, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(phone, password);
    ResponseModel responseModel;
    if (response.statusCode == 200) {

        authRepo.saveUserToken(response.body['token']);
        await authRepo.updateToken();

      responseModel = ResponseModel(true,
          response.body['token']);
    } else {
      responseModel = ResponseModel(false, response.body["errors"][0]["message"]!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
  bool clearSharedData() {
    return authRepo.clearSharedData();
  }
  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }
  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }
  String getUserToken() {
    return authRepo.getUserToken();
  }
  Future<void> updateToken() async {
    await authRepo.updateToken();
  }
}