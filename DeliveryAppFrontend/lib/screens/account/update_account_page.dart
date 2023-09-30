
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/base/go_to_sign_in_page.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/widgets/app_text_field.dart';

import '../../base/custom_button.dart';
import '../../base/custom_image.dart';
import '../../base/custom_snackbar.dart';
import '../../components/colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/splash_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:get/get.dart';

import '../../models/response_model.dart';
import '../../models/user_info_model.dart';
import '../../uitls/app_dimensions.dart';
import '../../uitls/styles.dart';
import '../../widgets/account_widgets.dart';
class UpdateAccountPage extends StatefulWidget {
  @override
  State<UpdateAccountPage> createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late bool _isLoggedIn;

  final List<Widget> _menuList = [
    AccountWidgets("lang".tr,icon: Icons.message,backgroundColor: Colors.redAccent),
    AccountWidgets("lang".tr,icon: Icons.message,backgroundColor: Colors.redAccent),
  ];
  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    Get.find<UserController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: Text("update".tr),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(onPressed: ()=>Get.offNamed(RouteHelper.getInitialRoute()),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height:800,
        child: GetBuilder<UserController>(builder: (userController) {

          print("my image is "+'${Get.find<SplashController>().configModel?.baseUrls?.customerImageUrl}/${userController.userInfoModel?.image}');
          if(userController.userInfoModel != null && _phoneController.text.isEmpty) {
            _firstNameController.text = userController.userInfoModel?.fName ?? '';
            _phoneController.text = userController.userInfoModel?.phone ?? '';
            _emailController.text = userController.userInfoModel?.email ?? '';
          }
          String path = '${Get.find<SplashController>().configModel?.baseUrls?.customerImageUrl}/${userController.userInfoModel?.image}';
          return _isLoggedIn ? userController.userInfoModel != null ? Column(

           children: [
             SizedBox(
               height: 10,
             ),
             Center(child: Stack(children: [
               ClipOval(child: userController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
                 userController.pickedFile!.path, width: 100, height: 100, fit: BoxFit.cover,
               ) : Image.file(
                 File(userController.pickedFile!.path), width: 100, height: 100, fit: BoxFit.cover,
               ):  Container(
                 width: 100,
                 height: 100,
                 child:ClipOval(
                     child: Get.find<UserController>().userInfoModel?.image==null?
                     Image.asset("assets/image/logo.png", fit: BoxFit.cover,):Image.network(path)
                 ),

                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(75),
                     color: AppColors.mainColor),
               )),
               Positioned(
                 bottom: 0, right: 0, top: 0, left: 0,
                 child: InkWell(
                   onTap: () => userController.pickImage(),
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.black.withOpacity(0.3), shape: BoxShape.circle,
                       border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                     ),
                     child: Container(
                       margin: EdgeInsets.all(25),
                       decoration: BoxDecoration(
                         border: Border.all(width: 2, color: Colors.white),
                         shape: BoxShape.circle,
                       ),
                       child: Icon(Icons.camera_alt, color: Colors.white),
                     ),
                   ),
                 ),
               ),
             ])),
             Expanded(

               child: Scrollbar(

                 child: SingleChildScrollView(
                   physics:BouncingScrollPhysics(),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                       children: [

                         Text(
                           'first_name'.tr,
                           style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                         ),
                         SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                         AppTextField(hintText: "first_name".tr, textController: _firstNameController, icon: Icons.phone,),
                         SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                         SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                         Text(
                           'email'.tr,
                           style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                         ),
                         SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                         AppTextField(hintText: "email".tr, textController: _emailController, icon: Icons.email,),

                         SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                         Row(children: [
                           Text(
                             'phone'.tr,
                             style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                           ),
                           SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                           Text('(${'non_changeable'})', style: robotoRegular.copyWith(
                             fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).errorColor,
                           )),
                         ]),
                         SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                         AppTextField(readOnly:true,hintText: "phone".tr, textController: _phoneController, icon: Icons.phone,),
                         SizedBox(
                           height: 20,
                         ),



                     SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                     !userController.isLoading ? CustomButton(
                       onPressed: () => _updateProfile(userController),
                       margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                       buttonText: 'update'.tr,
                     ) : Center(child: CircularProgressIndicator()),
                         GridView.builder(
                           physics: NeverScrollableScrollPhysics(),
                           shrinkWrap: true,
                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                             crossAxisCount:  2,
                             childAspectRatio: (1/1),
                             crossAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                             mainAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                           ),
                           itemCount: _menuList.length,
                           itemBuilder: (context, index) {
                             return GestureDetector(
                               onTap: ()=>Get.toNamed(RouteHelper.getLanguagePage("update")),
                               child: _menuList[index],
                             );
                           },
                         )
                   ]),
                 ),
               ),
             ),
           ],
          ) : Center(child: CircularProgressIndicator()) : GoToSignInPage();
        }),
      ),
    );
  }

  void _updateProfile(UserController userController) async {
    String _firstName = _firstNameController.text.trim();
    String _email = _emailController.text.trim();
    String _phoneNumber = _phoneController.text.trim();
    if (userController.userInfoModel?.fName == _firstName &&

        userController.userInfoModel?.email == _emailController.text && userController.pickedFile == null) {
      showCustomSnackBar('change_something_to_update'.tr);
    }else if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (_phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (_phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else {
      UserInfoModel _updatedUser = UserInfoModel(fName: _firstName,  email: _email, phone: _phoneNumber);
      ResponseModel _responseModel = await userController.updateUserInfo(_updatedUser, Get.find<AuthController>().getUserToken());
      if(_responseModel.isSuccess) {
        showCustomSnackBar('profile_updated_successfully'.tr, isError: false, title: "Success");
        //Get.offNamed(RouteHelper.getAccountPage());
      }else {
        showCustomSnackBar(_responseModel.message);
      }
    }
  }
}
