import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shopping_app/controllers/auth_controller.dart';
import 'package:shopping_app/controllers/cart_controller.dart';
import 'package:shopping_app/controllers/popular_product.dart';
import 'package:shopping_app/controllers/product_controller.dart';
import 'package:shopping_app/controllers/user_controller.dart';
import 'package:shopping_app/helper/helper_notifications.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/screens/food/detail_food.dart';
import 'package:shopping_app/screens/food/more_food.dart';
import 'package:shopping_app/uitls/app_constants.dart';
import 'package:shopping_app/uitls/message.dart';
import 'package:shopping_app/uitls/scroll_behavior.dart';
import 'components/colors.dart';
import 'controllers/localization_controller.dart';
import 'helper/get_dependecies.dart' as dep;
import 'package:get/get.dart';

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print("onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
}
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<void> main() async {
 // setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Map<String, Map<String, String>> _languages = await dep.init();

  int? _orderID;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        _orderID = remoteMessage.notification?.titleLocKey != null ?
        int.parse(remoteMessage.notification!.titleLocKey!) : null;
      }
      await HelperNotification.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  }catch(e) {}

  runApp(MyApp(languages: _languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  MyApp({required this.languages });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.find<CartController>().getCartsData();
      return  GetBuilder<ProductController>(builder:(_){
          return GetBuilder<LocalizationController>(builder: (localizationController){
            return GetBuilder<PopularProduct>(builder: (_){
              return GetMaterialApp(
                scrollBehavior: AppScrollBehavior(),
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  primaryColor: AppColors.mainColor,
                  fontFamily: "Lato",
                ),
                locale: localizationController.locale,
                translations: Messages(languages: languages),
                fallbackLocale: Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode),
                initialRoute: RouteHelper.getSplashRoute(),
                getPages: RouteHelper.routes,
                defaultTransition: Transition.topLevel,
              );
            });
          });
        });
  }
}

/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Map<String, Map<String, String>> _languages = await dep.init();

  int? _orderID;
  try {
    if (GetPlatform.isMobile) {
      // 1. Initialize the Firebase app
      await Firebase.initializeApp();

      // 2. Instantiate Firebase Messaging
      FirebaseMessaging _messaging = FirebaseMessaging.instance;
    //  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // 3. On iOS, this helps to take the user permissions
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
       // String? token = await _messaging.getToken();
        //print("The token is "+token!);
        // For handling the received notifications
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          // Parse the message received

        });
        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
      } else {
        print('User declined or has not accepted permission');
      }
      final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
      FirebaseMessaging.instance.requestPermission();
      if (remoteMessage != null) {
        _orderID = remoteMessage.notification!.titleLocKey != null ? int.parse(remoteMessage.notification!.titleLocKey!) : null;
        print(".... firebase message ...${remoteMessage.notification?.title}");
      }else{
        print("........firebase no message ..........");
      }
      await HelperNotification.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  }catch(e) {}


  runApp(MyApp(languages: _languages));
}*/
