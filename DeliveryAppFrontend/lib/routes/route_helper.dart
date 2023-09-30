import 'package:get/get.dart';
import 'package:shopping_app/base/go_to_sign_in_page.dart';
import 'package:shopping_app/screens/account/account_page.dart';
import 'package:shopping_app/screens/account/update_account_page.dart';
import 'package:shopping_app/screens/address/add_address_page.dart';
import 'package:shopping_app/screens/address/pick_map_screen.dart';
import 'package:shopping_app/screens/auth/sign_in_page.dart';
import 'package:shopping_app/screens/auth/sign_up_page.dart';
import 'package:shopping_app/screens/cart/cart_page.dart';
import 'package:shopping_app/screens/food/detail_food.dart';
import 'package:shopping_app/screens/home/home_page.dart';
import 'package:shopping_app/screens/food/more_food.dart';
import 'package:shopping_app/screens/splash/splash_screen.dart';

import '../models/order_model.dart';
import '../screens/checkout/order_successful_page.dart';
import '../screens/checkout/payment_page.dart';
import '../screens/langugae/language_page.dart';
import '../screens/order/order_detail_screen.dart';
import '../screens/search/seach_product_page.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String detailFood = '/detail-food';
  static const String moreFood = '/more-food';
  static const String accountPage='/account-page';
  static const String cartPage='/cart-page';
  static const String signUp='/sign-up';
  static const String signIn='/sign-in';
  //static const String address = '/address';
  static const String addAddress = '/add-address';
  static const String pickMap = '/pick-map';
  //payment route
  static const String payment = '/payment';
  static const String orderSuccess = '/order-successful';
  static const String updateProfile = '/update-profile';
  static const String search ='/search';

  /*
  language
   */
  static const String language = '/language';
/*
order details
 */
  static const String orderDetails = '/order-details';
  static String getPickMapRoute(String page, bool canRoute) => '$pickMap?page=$page&route=${canRoute.toString()}';

  static String getSplashRoute() => '$splash';
  static String getInitialRoute()=> '$initial';
  static String getSignUpRoute() => '$signUp';
  static String getSignInRoute() => '$signIn';
  //static String getAddressRoute() => '$address';
  static String getAddAddressRoute()=>'$addAddress';
  static String getRecommendedFoodRoute(int pageId, String page)=> '$detailFood?id=$pageId&page=$page';
  static String getPopularFoodRoute(int pageId, String page)=>'$moreFood?id=$pageId&page=$page';
  static String getAccountPage()=>'$accountPage';
  static String getCartPage(int pageId, String page)=>'$cartPage?id=$pageId&page=$page';
  static String getPaymentRoute(String id, int user) => '$payment?id=$id&user=$user';
  static String getOrderSuccessRoute(String orderID, String status) => '$orderSuccess?id=$orderID&status=$status';

  static String getUpdateProfile()=>'$updateProfile';
  static String getSearchRoute()=>'$search';
  static String getLanguagePage(String page) => '$language?page=$page';
  static String getOrderDetailsRoute(int orderID) {
    return '$orderDetails?id=$orderID';
  }
  static List<GetPage> routes = [
    GetPage(name: pickMap, page: () {
      PickMapScreen _pickMapScreen = Get.arguments;
      bool _fromAddress = Get.parameters['page'] == 'add-address';
      return (_fromAddress && _pickMapScreen == null) ? GoToSignInPage() : _pickMapScreen != null ? _pickMapScreen
          : PickMapScreen(
        fromSignUp: Get.parameters['page'] == signUp, fromAddAddress: _fromAddress,
        route: Get.parameters['page']??"",
        canRoute: Get.parameters['route'] == 'true',
      );
    }),
    GetPage(name: signUp, page: () {
      return SignUpPage();
    }),
    GetPage(name: signIn, page: () {
      return SignInPage();
    }),
    GetPage(name: splash, page: () {
      return SplashScreen();
    }),
    GetPage(name:initial, page:(){
      print("GetPage name:home");
      return HomePage();
    },
        transition: Transition.fadeIn
    ),
    GetPage(name: detailFood, page: (){

      return DetailFood(pageId:int.parse(Get.parameters['id'].toString()), page:Get.parameters['page']!);
    },
        transition: Transition.fadeIn

    ),
    GetPage(name: moreFood, page: (){
      return MoreFood(pageId:int.parse(Get.parameters['id']!), page:Get.parameters['page']!);
    },
        transition: Transition.fadeIn
    ),
    GetPage(name:accountPage, page: (){
      return AccountPage();
    }),
    GetPage(name:cartPage, page:(){
      return CartPage(pageId:int.parse(Get.parameters['id']!), page:Get.parameters['page']!);
    },
        transition: Transition.fadeIn
    ),
    //GetPage(name: address, page: () => AddressScreen()),
    GetPage(name: addAddress, page: () => AddAddressScreen()),
    GetPage(name: payment, page: () => PaymentScreen(orderModel: OrderModel(
        id: int.parse(Get.parameters['id']!), userId: int.parse(Get.parameters['user']!,
    )))),
    GetPage(name: orderSuccess, page: () => OrderSuccessfulScreen(
      orderID: Get.parameters['id']!, status: Get.parameters['status'].toString().
    contains('success') ? 1 : 0,
    )),
    GetPage(name:updateProfile, page:()=>UpdateAccountPage()),
    GetPage(name: search, page: () => SearchScreen()),
    GetPage(name: language, page: () => LanguagePage(fromMenu: Get.parameters['page'] == 'update')),
    GetPage(name: orderDetails, page: () {
      return  OrderDetailsScreen(orderId: int.parse(Get.parameters['id'] ?? '0'), orderModel: null);
    }),
  ];
}