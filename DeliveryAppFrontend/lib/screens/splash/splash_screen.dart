import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/controllers/auth_controller.dart';
import 'package:shopping_app/controllers/cart_controller.dart';
import 'package:shopping_app/controllers/location_controller.dart';
import 'package:shopping_app/controllers/popular_product.dart';
import 'package:shopping_app/controllers/product_controller.dart';
import 'package:shopping_app/controllers/user_controller.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/screens/home/home_page.dart';
import 'package:get/get.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';

import '../../controllers/splash_controller.dart';
import '../../uitls/app_constants.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  late Animation<double> animation;
  late AnimationController _controller;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  @override
  dispose() {
    _controller.dispose();
    _onConnectivityChanged.cancel();
    super.dispose();
  }

  Future<void>_loadResources(bool reload)async {
    await  Get.find<ProductController>().getRecommendedProductList(reload);
    await  Get.find<PopularProduct>().getPopularProductList(reload);
    if(Get.find<AuthController>().isLoggedIn()) {
      await Get.find<UserController>().getUserInfo();
      await Get.find<LocationController>().getAddressList();
      if(Get.find<LocationController>().addressList.isNotEmpty){
        var address = Get.find<LocationController>().addressList[0];
        await Get.find<LocationController>().saveUserAddress(address);
      }
    }
  }
  void _removeResource(){
     Get.find<CartController>().clear();
     Get.find<CartController>().removeCartSharedPreference();
  }
  @override
  void initState() {
    super.initState();
    bool _firstTime = true;

    Get.find<AuthController>().updateToken();
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!_firstTime) {

        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.yellow : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection': 'connected',
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
          Timer(Duration(seconds: 3),

                  ()=>Get.offNamed(RouteHelper.getInitialRoute())
          );
        }
      }
      _firstTime = false;
    });

   // _loadResources(true);
    // _removeResource();
    _controller =
    new AnimationController(vsync: this, duration: Duration(seconds: 2))..forward()
    ;
    animation = new CurvedAnimation(parent: _controller,
        curve: Curves.linear);
    Get.find<SplashController>().initSharedData();
    print("I am in init state");
    _route();
  }
  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if(isSuccess) {
        Timer(Duration(seconds: 3), () async {
          int _minimumVersion = 0;
              if (Get.find<AuthController>().isLoggedIn()) {
                print("I am going to print token");
                  Get.offNamed(RouteHelper.getInitialRoute());
                  print("my image is "+'${Get.find<SplashController>().configModel?.baseUrls?.customerImageUrl}'
                      '/${(Get.find<UserController>().userInfoModel != null && Get.find<AuthController>().isLoggedIn()) ? Get.find<UserController>().userInfoModel?.image : ''}');
              } else {

               if (Get.find<SplashController>().showIntro()!=null) {
                  if(AppConstants.languages.length > 1) {
                    Get.offNamed(RouteHelper.getLanguagePage('splash'));
                  }else {
                    Get.offNamed(RouteHelper.getSignInRoute());
                  }
                } else {
              // _loadResources(true);
                  Get.offNamed(RouteHelper.getSignInRoute());
                }

              }

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.white,
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
              child: Center(child: Image.asset("img/logo part 1.png", width:Dimensions.SPLASH_IMG_WIDTH))),
          Center(child: Image.asset("img/logo part 2.png", width:Dimensions.SPLASH_IMG_WIDTH,)),
        ],
      ),
    );
  }
}
