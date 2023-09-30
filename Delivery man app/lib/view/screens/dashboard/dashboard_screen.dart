import 'package:the_best_food/controller/auth_controller.dart';
import 'package:the_best_food/controller/order_controller.dart';
import 'package:the_best_food/helper/notification_helper.dart';
import 'package:the_best_food/helper/route_helper.dart';
import 'package:the_best_food/util/dimensions.dart';
import 'package:the_best_food/view/base/custom_alert_dialog.dart';
import 'package:the_best_food/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:the_best_food/view/screens/dashboard/widget/new_request_dialog.dart';
import 'package:the_best_food/view/screens/home/home_screen.dart';
import 'package:the_best_food/view/screens/profile/profile_screen.dart';
import 'package:the_best_food/view/screens/request/order_request_screen.dart';
import 'package:the_best_food/view/screens/order/order_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../../util/colors.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final _channel = const MethodChannel('com.dbestech/app_retain');
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  int _selectedIndex=0;



  void onTap(int index){
    setState(() {
      _selectedIndex=index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController();


    var androidInitialize = AndroidInitializationSettings('notification_icon');
    var iOSInitialize = DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if(Get.find<OrderController>().latestOrderList != null) {
      //   _orderCount = Get.find<OrderController>().latestOrderList.length;
      // }
      print("onMessage: ${message.data}");
      String? _type = message.notification?.bodyLocKey;
      String? _orderID = message.notification?.titleLocKey;
      if(_type != 'assign' && _type != 'new_order') {
        NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, false);
      }
      Get.find<OrderController>().getCurrentOrders();
      Get.find<OrderController>().getLatestOrders();
      //Get.find<OrderController>().getAllOrders();
      if(_type == 'new_order') {
        //_orderCount = _orderCount + 1;
        Get.dialog(NewRequestDialog(isRequest: true, onTap: () => _navigateRequestPage()));
      }else if(_type == 'assign' && _orderID != null && _orderID.isNotEmpty) {
        Get.dialog(NewRequestDialog(isRequest: false, onTap: () => _setPage(0)));
      }else if(_type == 'block') {
        Get.find<AuthController>().clearSharedData();
        Get.find<AuthController>().stopLocationRecord();
        Get.offAllNamed(RouteHelper.getSignInRoute());
      }
    });


  }

  void _navigateRequestPage() {
    if(Get.find<AuthController>().profileModel != null && Get.find<AuthController>().profileModel?.active == 1
        && Get.find<OrderController>().currentOrderList != null && Get.find<OrderController>().currentOrderList!.length < 1) {
      _setPage(1);
    }else {
      if(Get.find<AuthController>().profileModel == null || Get.find<AuthController>().profileModel?.active == 0) {
        Get.dialog(CustomAlertDialog(description: 'you_are_offline_now'.tr, onOkPressed: () => Get.back()));
      }else {
        //Get.dialog(CustomAlertDialog(description: 'you_have_running_order'.tr, onOkPressed: () => Get.back()));
        _setPage(1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_pageIndex != 0) {
          _setPage(0);
          return false;
        }else {
          if (GetPlatform.isAndroid && Get.find<AuthController>().profileModel!.active == 1) {
            _channel.invokeMethod('sendToBackground');
            return false;
          } else {
            return true;
          }
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedFontSize: 0.0,
          unselectedFontSize: 0.0,
          onTap: onTap,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.mainColor,
          unselectedItemColor: Colors.amberAccent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined),
                label: "home"
            ),
            BottomNavigationBarItem(icon: Icon(Icons.archive),
                label: "home"
            ),

            BottomNavigationBarItem(icon: Icon(Icons.person),
                label: "home"

            )
          ],
        ),

        body: PageView(
          children: [
            HomeScreen(),
            OrderRequestScreen(onTap: () => _setPage(0)),
            //OrderScreen(),
            ProfileScreen(),
          ],
          onPageChanged: (pageIndex) {
            setState(() {
              _selectedIndex = pageIndex;
            });
          },
          controller: _pageController,


        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
