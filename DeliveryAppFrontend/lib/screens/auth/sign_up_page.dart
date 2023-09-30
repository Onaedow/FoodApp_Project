import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/base/custom_loader.dart';
import 'package:shopping_app/base/custom_snackbar.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/controllers/auth_controller.dart';
import 'package:shopping_app/models/countries_json.dart';
import 'package:shopping_app/models/signup_body.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/widgets/app_text_field.dart';
import 'package:shopping_app/widgets/big_text.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var verificationController = TextEditingController();
  int choose_index = 0;
  int choose_now_index = 0;
  Timer? _timer;
  int code_time = 30;
  bool code_status = true;

  @override
  void deactivate(){
    super.deactivate();
    print("close-------");
    if(_timer!=null){
      _timer?.cancel();
    }
  }

  go_code(AuthController authController){
    String _number = phoneController.text.trim();
    String _country_code = countryCodes.elementAt(choose_index)["Code"]!;
    print(_country_code);
    if (_number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
      return;
    }
    if (_country_code.isEmpty) {
      showCustomSnackBar('enter_country_code');
      return;
    }
    if(code_status){
      code_status = false;
      send_verify(authController);
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if(code_time>0){
        setState(() {
          code_time--;
        });
      }else{
        setState(() {
          code_time = 30;
        });
        code_status = true;
        _timer?.cancel();
      }
    });
    }else{
      print(code_status);
    }
  }

   Future ChooseCountry(BuildContext context){
     double w = MediaQuery.of(context).size.width;
     double h = MediaQuery.of(context).size.height;

     return Get.bottomSheet(
       Container(
           height: h/2,
           color: Colors.white,
           child:Column(
             children: [
               Container(
                   width: w,
                   height: 50,
                   padding: EdgeInsets.only(left: 15,right:15),
                   child:Row(
                       mainAxisAlignment:MainAxisAlignment.spaceBetween,
                       children: [
                         GestureDetector(
                             child:Text(
                               "Cancel",
                               textAlign: TextAlign.center,
                             ),
                             onTap: () {

                               Get.back();
                             }),

                         GestureDetector(
                             child:Text(
                               "Confirm",
                               textAlign: TextAlign.center,
                             ),
                             onTap: () {
                              // controller.saveAddress(type);
                               setState(() {
                                 choose_index=choose_now_index;
                               });
                               Get.back();
                             })
                       ])),
               Container(
                 width: w,
                 height: h/2-60,
                 child: CupertinoPicker.builder(
                   backgroundColor: Colors.white,
                   itemExtent: 30,
                   magnification:1.1,
                   diameterRatio:1.0,
                   selectionOverlay:CupertinoPickerDefaultSelectionOverlay(background:Color.fromRGBO(200, 200, 200, 0.1)),
                   scrollController: FixedExtentScrollController(initialItem:0),
                   useMagnifier: true,
                   childCount:countryCodes.length,
                   itemBuilder: (BuildContext context, int index){
                     return Container(
                       height: 27,
                       child: Text(
                         '+${countryCodes.elementAt(index)["Code"]!} ${countryCodes.elementAt(index)["Name"]!} ',
                         textAlign: TextAlign.left,
                       ),
                     );
                   },
                   onSelectedItemChanged: (value) {
                     print(value);
                     choose_now_index = value;

                   },
                 ),
               ),
             ],
           )
       ),
       barrierColor: Color.fromRGBO(0, 0, 0, 0.6),
       isDismissible: true,
       enableDrag: false,
     );
   }


  @override
  Widget build(BuildContext context) {

    List images =[
      "g.png",
      "t.png",
      "f.png"
    ];

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(

      backgroundColor: Colors.white,
      body:GetBuilder<AuthController>(builder: (authController) {
        return
         !authController.isLoading? GestureDetector(
           child:  SingleChildScrollView(
             physics: BouncingScrollPhysics(),
             child: Column(
               children: [
                 Container(
                   width: w,
                   height: h * 0.25,
                   decoration: BoxDecoration(
                       color: Colors.white
                   ),
                   child: SingleChildScrollView(
                     child: Column(
                       children: [
                         SizedBox(height: h * 0.05,),
                         CircleAvatar(
                           backgroundColor: Colors.white70,
                           radius: 80,
                           backgroundImage: AssetImage(
                               "img/logo part 1.png"
                           ),
                         )
                       ],
                     ),
                   ),
                 ),
                 Container(
                   margin: const EdgeInsets.only(left: 20, right: 20),
                   width: w,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [

                       SizedBox(height: 20,),
                       AppTextField(hintText:"email".tr, textController:emailController, icon: Icons.email,),
                       SizedBox(height: 20,),
                       AppTextField(obscureText:true,hintText:"password".tr, textController:passwordController, icon:Icons.password_sharp),
                       SizedBox(height: 20,),
                       //  AppTextField(hintText:"phone".tr, textController:phoneController, icon:Icons.phone),
                       Container(
                         decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(15),
                             boxShadow: [
                               BoxShadow(
                                   blurRadius: 3,
                                   spreadRadius: 1,
                                   offset: Offset(1, 1),
                                   color:Colors.grey.withOpacity(0.2)
                               )
                             ]
                         ),
                         child: TextField(
                           keyboardType: TextInputType.number,
                           maxLines: 1,
                           obscureText: false,
                           readOnly: false,
                           controller: phoneController,
                           decoration: InputDecoration(
                               hintText: "phone".tr,
                               // prefixIcon: Icon(
                               //     Icons.phone, color: AppColors.mainColor),
                               prefixIcon: GestureDetector(
                                 onTap: () { ChooseCountry(context); },child: Container(margin:EdgeInsets.only(top: 15, left: 20,right:15),child: Text("+${countryCodes.elementAt(choose_index)["Code"]}"),),),
                               focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(15),
                                   borderSide: BorderSide(
                                       color: Colors.white,
                                       width: 1.0
                                   )
                               ),
                               enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(15),
                                   borderSide: BorderSide(
                                       color: Colors.white,
                                       width: 1.0
                                   )
                               ),
                               border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(15)
                               )
                           ),
                         ),
                       ),
                       SizedBox(height: 20,),
                       Container(
                         decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(15),
                             boxShadow: [
                               BoxShadow(
                                   blurRadius: 3,
                                   spreadRadius: 1,
                                   offset: Offset(1, 1),
                                   color:Colors.grey.withOpacity(0.2)
                               )
                             ]
                         ),
                         child: TextField(
                           keyboardType: TextInputType.number,
                           maxLines: 1,
                           obscureText: false,
                           readOnly: false,
                           controller: verificationController,
                           decoration: InputDecoration(
                               alignLabelWithHint:true,
                               hintText: "verification code",
                               prefixIcon: Icon(
                                   Icons.access_alarm, color: AppColors.mainColor),
                               suffixIcon: GestureDetector(
                                 onTap: () { go_code(authController); },child: Container(margin:EdgeInsets.only(top: 15, left: 20,right:30),child: Text("${code_time==30?"Send Code":code_time} ${code_time==30?"":"s"}",style:TextStyle(
                                 color:Colors.red,
                               )),),),
                               focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(15),
                                   borderSide: BorderSide(
                                       color: Colors.white,
                                       width: 1.0
                                   )
                               ),
                               enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(15),
                                   borderSide: BorderSide(
                                       color: Colors.white,
                                       width: 1.0
                                   )
                               ),
                               border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(15)
                               )
                           ),
                         ),
                       ),
                       SizedBox(height: 20,),
                       AppTextField(hintText:"first_name".tr, textController:nameController, icon:Icons.person),
                       SizedBox(height: 20,),


                     ],
                   ),
                 ),
                 SizedBox(height: 20,),
                 GestureDetector(
                   onTap: () {
                     _register(authController);
                   },
                   child: Container(
                     width: w * 0.5,
                     height: h * 0.08,
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(15),
                         color: AppColors.mainColor
                     ),
                     child: Center(
                       child: BigText(
                         text:"sign_up".tr,
                         size: 30,
                         color: Colors.white,
                       ),
                     ),
                   ),
                 ),
                 SizedBox(height: 10,),
                 RichText(
                     text: TextSpan(
                         recognizer: TapGestureRecognizer()
                           ..onTap = () => Get.back(),
                         text: "have_an_account".tr,
                         style: TextStyle(
                             fontSize: 20,
                             color: Colors.grey[500]
                         )
                     )
                 ),
                 SizedBox(height: w * 0.08),
                 RichText(text: TextSpan(
                   text: "sign_up_method".tr,
                   style: TextStyle(
                       color: Colors.grey[500],
                       fontSize: 16
                   ),

                 )),
                 Wrap(
                   children: List<Widget>.generate(
                       3,
                           (index) {
                         return GestureDetector(
                           onTap: () {

                           },
                           child: Padding(
                             padding: const EdgeInsets.all(10.0),
                             child: CircleAvatar(
                               radius: 30,
                               backgroundColor: Colors.transparent,
                               //backgroundColor: AppColors.mainColor,
                               child: CircleAvatar(
                                 radius: 25,
                                 backgroundImage: AssetImage(
                                     "img/" + images[index]
                                 ),
                               ),
                             ),
                           ),
                         );
                       }
                   ),
                 )
               ],
             ),
           ),
           onTap: (){
             Get.focusScope?.unfocus();
           },
         ):CustomLoader();

      }));
    }

    void send_verify(AuthController authController) async{
      String _number = phoneController.text.trim();
      String _country_code = countryCodes.elementAt(choose_index)["Code"]!;
      VerificationBody verificationBody = VerificationBody(
          country_code: _country_code,
          phone: _number);
       await authController.verification(verificationBody);
    }

  void _register(AuthController authController) async {
    String _firstName = nameController.text.trim();
    String _email = emailController.text.trim();
    String _number = phoneController.text.trim();
    String _password = passwordController.text.trim();
    String _country_code = countryCodes.elementAt(choose_index)["Code"]!;
    String _sms_code = verificationController.text.trim();

/*    if (_firstName.isEmpty) {
      showCustomSnackBar("Type in your name", title:"Name");

    }else if (_email.isEmpty) {
      showCustomSnackBar("Type in your Email", title:"Email");
    }else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar("Type in correct Email", title:"Email");
    }else if (_number.isEmpty) {
      showCustomSnackBar("Type in your Phone Number", title:"Phone Number");
    }else if (_password.isEmpty) {
      showCustomSnackBar("Type in your Password", title:"Password");
    }else if (_password.length < 6) {
      showCustomSnackBar("Type in equal or more than 6 characters", title:"Password");*/

   if (_firstName.isEmpty) {
   showCustomSnackBar('enter_your_first_name'.tr);
   return;
   }else if (_email.isEmpty) {
   showCustomSnackBar('enter_email_address'.tr);
   return;
   }else if (!GetUtils.isEmail(_email)) {
   showCustomSnackBar('enter_a_valid_email_address'.tr);
   return;
   }else if (_number.isEmpty) {
   showCustomSnackBar('enter_phone_number'.tr);
   return;
   }else if (_number.length < 6) {
   showCustomSnackBar('enter_a_valid_phone_number'.tr);
   return;
   }else if (_sms_code.length < 4) {
   showCustomSnackBar('enter_a_valid_sms_code');
   return;
   } else {
      SignUpBody signUpBody = SignUpBody(fName: _firstName,
          email: _email,
          phone: _number, password: _password,country_code:_country_code,sms_code:_sms_code);
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
            print("success registration");
            Get.offAllNamed(RouteHelper.getInitialRoute());
        }else {
         // Get.snackbar("registration error", status.message);
          showCustomSnackBar(status.message);

        }
      });
    }
  }
}
