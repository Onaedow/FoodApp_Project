import 'package:the_best_food/data/api/api_checker.dart';
import 'package:the_best_food/data/model/response/notification_model.dart';
import 'package:the_best_food/data/repository/notification_repo.dart';
import 'package:the_best_food/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController implements GetxService {
  late NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});

  List<NotificationModel>? _notificationList;
  List<NotificationModel>? get notificationList => _notificationList;

  Future<void> getNotificationList() async {
    Response? response = await notificationRepo?.getNotificationList();
    if (response?.statusCode == 200) {
      _notificationList = [];
    response?.body.forEach((notification) {
        NotificationModel _notification = NotificationModel.fromJson(notification);
        _notification.title = notification['data']['title'];
        _notification.description = notification['data']['description'];
        _notification.image = notification['data']['image'];
        _notificationList?.add(_notification);
      });
      _notificationList?.sort((a, b) {
        return DateConverter.isoStringToLocalDate(a.updatedAt!).compareTo(DateConverter.isoStringToLocalDate(b.updatedAt!));
      });
      Iterable iterable = _notificationList!.reversed;
      _notificationList = iterable.toList().cast<NotificationModel>();
    } else {
      ApiChecker.checkApi(response!);
    }
    update();
  }

  void saveSeenNotificationCount(int count) {
    notificationRepo?.saveSeenNotificationCount(count);
  }

  int getSeenNotificationCount() {
    return notificationRepo!.getSeenNotificationCount();
  }

}
