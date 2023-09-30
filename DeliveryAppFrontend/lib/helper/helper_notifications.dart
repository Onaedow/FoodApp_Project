import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import '../controllers/auth_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/order_controller.dart';
import 'package:get/get.dart';

import '../routes/route_helper.dart';
import '../uitls/app_constants.dart';
import 'package:http/http.dart' as http;
class HelperNotification {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = new AndroidInitializationSettings('notification_icon');
    var iOSInitialize = new DarwinInitializationSettings();
    var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onDidReceiveNotificationResponse: (data){
      try{
        if(data != null && data.payload!.isNotEmpty) {
          Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(data.payload!)));
        }else {

          //  Get.toNamed(RouteHelper.getNotificationRoute());
        }
      }catch (e) {
      }
    });
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("..................onMessage................");
      print("onMessage: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");

      HelperNotification.showNotification(message, flutterLocalNotificationsPlugin, false);
      if(Get.find<AuthController>().isLoggedIn()) {

        // Get.find<OrderController>().getRunningOrders(1);
        // Get.find<OrderController>().getHistoryOrders(1);
        Get.find<NotificationController>().getNotificationList(true);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      print("onOpenApp: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
      try{
        if(message.notification?.titleLocKey != null && message.notification?.titleLocKey!=null) {
          Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(message.notification!.titleLocKey!)));
        }else {

          // Get.toNamed(RouteHelper.getNotificationRoute());
        }
      }catch (e) {

        print(e.toString());
      }
    });
  }



  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln, bool data) async {
    if(!GetPlatform.isIOS) {

      String? _title;
      String? _body;
      String? _orderID;
      String? _image;
      if(data) {
        _title = message.data['title'];
        _body = message.data['body'];
        _orderID = message.data['order_id'];
        _image = (message.data['image'] != null && message.data['image'].isNotEmpty)
            ? message.data['image'].startsWith('http') ? message.data['image']
            : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.data['image']}' : null;
      }else {
        _title = message.notification?.title;
        _body = message.notification?.body;
        _orderID = message.notification?.titleLocKey;
        if(GetPlatform.isAndroid) {
          _image = (message.notification?.android?.imageUrl != null &&
              message.notification?.android?.imageUrl!=null)
              ? message.notification!.android!.imageUrl!.startsWith('http') ? message.notification?.android?.imageUrl
              : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification?.android?.imageUrl}' : null;
        }else if(GetPlatform.isIOS) {
          _image = (message.notification?.apple?.imageUrl != null &&
              message.notification?.apple?.imageUrl!=null)
              ? message.notification!.apple!.imageUrl!.startsWith('http') ? message.notification?.apple?.imageUrl
              : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification?.apple?.imageUrl}' : null;
        }
      }


      if(_image != null && _image.isNotEmpty) {
        try{
          await showBigPictureNotificationHiddenLargeIcon(_title!, _body!, _orderID!, _image, fln);
        }catch(e) {
          await showBigTextNotification(_title!, _body!, _orderID!, fln);
        }
      }else {
        await showBigTextNotification(_title!, _body!, _orderID??"10", fln);
      }
    }
  }

  static Future<void> showTextNotification(String title, String body, String orderID, FlutterLocalNotificationsPlugin fln) async {

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'dbfood', 'dbfood', playSound: false,
      importance: Importance.max, priority: Priority.max,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigTextNotification(String title, String body, String orderID,
      FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id_5', 'dbfood 2', importance: Importance.high,
      styleInformation: bigTextStyleInformation, priority: Priority.high,
      playSound: true,
      //sound: RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(String title, String body, String orderID, String image, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: title, htmlFormatContentTitle: true,
      summaryText: body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'dbfood', 'dbfood',
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

}


