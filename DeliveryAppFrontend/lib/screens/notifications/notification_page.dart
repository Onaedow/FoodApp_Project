
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/base/go_to_sign_in_page.dart';

import '../../base/custom_image.dart';
import '../../base/no_data_found.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/splash_controller.dart';
import 'package:get/get.dart';

import '../../helper/app_date_converter.dart';
import '../../uitls/app_dimensions.dart';
import '../../uitls/styles.dart';
import 'dialogue_notification.dart';
class NotificationPage extends StatefulWidget {

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  void _loadData() async {
    Get.find<NotificationController>().clearNotification();
    if(Get.find<SplashController>().configModel == null) {
      await Get.find<SplashController>().getConfigData();
    }
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<NotificationController>().getNotificationList(true);
    }
  }
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar:AppBar(
        title: Text("notifications".tr),
      ),
      body: Get.find<AuthController>().isLoggedIn() ? GetBuilder<NotificationController>(builder: (notificationController) {
        if(notificationController.notificationList != null) {
          notificationController.saveSeenNotificationCount(notificationController.notificationList.length);
        }
        List<DateTime> _dateTimeList = [];
        return notificationController.notificationList != null ? notificationController.notificationList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await notificationController.getNotificationList(true);
          },
          child: Scrollbar(child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: ListView.builder(
              itemCount: notificationController.notificationList.length,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DateTime _originalDateTime = DateConverter.dateTimeStringToDate(notificationController.notificationList[index].createdAt);
                DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
                bool _addTitle = false;
                if(!_dateTimeList.contains(_convertedDate)) {
                  _addTitle = true;
                  _dateTimeList.add(_convertedDate);
                }
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  _addTitle ? Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Text(DateConverter.dateTimeStringToDateOnly(notificationController.notificationList[index].createdAt)),
                  ) : SizedBox(),

                  InkWell(
                    onTap: () {
                      showDialog(context: context, builder: (BuildContext context) {
                        return DialogueNotification(notificationModel: notificationController.notificationList[index]);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Row(children: [

                        ClipOval(child:
                        CustomImage(
                          height: 40, width: 40, fit: BoxFit.cover,
                          image: '${Get.find<SplashController>().configModel?.baseUrls?.notificationImageUrl}'
                              '/${notificationController.notificationList[index].data.image}', placeholder: '',
                        )),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            notificationController.notificationList[index].data.title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                          Text(
                            notificationController.notificationList[index].data.description ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          ),
                        ])),

                      ]),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Divider(color: Theme.of(context).disabledColor, thickness: 1),
                  ),

                ]);
              },
            ))),
          )),
        ) : NoDataScreen(text: 'no_notification_found'.tr) : Center(child: CircularProgressIndicator());
      }) : GoToSignInPage(),
    );
  }
}
