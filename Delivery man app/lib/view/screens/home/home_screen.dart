import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:the_best_food/controller/auth_controller.dart';
import 'package:the_best_food/controller/notification_controller.dart';
import 'package:the_best_food/controller/order_controller.dart';
import 'package:the_best_food/helper/price_converter.dart';
import 'package:the_best_food/helper/route_helper.dart';
import 'package:the_best_food/util/colors.dart';
import 'package:the_best_food/util/dimensions.dart';
import 'package:the_best_food/util/images.dart';
import 'package:the_best_food/util/styles.dart';
import 'package:the_best_food/view/base/big_text.dart';
import 'package:the_best_food/view/base/confirmation_dialog.dart';
import 'package:the_best_food/view/base/custom_alert_dialog.dart';
import 'package:the_best_food/view/base/custom_snackbar.dart';
import 'package:the_best_food/view/base/order_shimmer.dart';
import 'package:the_best_food/view/base/order_widget.dart';
import 'package:the_best_food/view/base/title_widget.dart';
import 'package:the_best_food/view/screens/home/widget/count_card.dart';
import 'package:the_best_food/view/screens/home/widget/earning_widget.dart';
import 'package:the_best_food/view/screens/order/running_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {

  Future<void> _loadData() async {
    //Get.find<OrderController>().getIgnoreList();
    //Get.find<OrderController>().removeFromIgnoreList();
    await Get.find<AuthController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();
    await Get.find<NotificationController>().getNotificationList();
    /*bool _isBatteryOptimizationDisabled = await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    if(!_isBatteryOptimizationDisabled) {
      DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    }*/
  }

  @override
  Widget build(BuildContext context) {
    _loadData();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Image.asset(Images.logo, height: 30, width: 30),
        ),
        titleSpacing: 0, elevation: 0,
        /*title: Text(AppConstants.APP_NAME, maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoMedium.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_DEFAULT,
        )),*/
        title: Image.asset(Images.logo_name, width: 120),
        actions: [
          IconButton(
            icon: GetBuilder<NotificationController>(builder: (notificationController) {
              bool _hasNewNotification = false;
              if(notificationController.notificationList != null) {
                _hasNewNotification = notificationController.notificationList!.length
                    != notificationController.getSeenNotificationCount();
              }
              return Stack(children: [
                Icon(Icons.notifications, size: 25, color: AppColors.yellowColor.withOpacity(0.5)),
                _hasNewNotification ? Positioned(top: 0, right: 0, child: Container(
                  height: 10, width: 10, decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Theme.of(context).cardColor),
                ),
                )) : SizedBox(),
              ]);
            }),
            onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
          ),
          GetBuilder<AuthController>(builder: (authController) {
            return GetBuilder<OrderController>(builder: (orderController) {
              return (authController.profileModel != null && orderController.currentOrderList != null) ? FlutterSwitch(
                width: 75, height: 30, valueFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, showOnOff: true,
                activeText: 'online'.tr, inactiveText: 'offline'.tr, activeColor: Theme.of(context).primaryColor,
                value: authController.profileModel!.active == 1, onToggle: (bool isActive) async {
                  if(!isActive && orderController.currentOrderList!.length > 0) {
                    showCustomSnackBar('you_can_not_go_offline_now'.tr);
                  }else {
                    if(!isActive) {
                      Get.dialog(ConfirmationDialog(
                        icon: Images.warning, description: 'are_you_sure_to_offline'.tr,
                        onYesPressed: () {
                          Get.back();
                          authController.updateActiveStatus();
                        },
                      ));
                    }else {
                      LocationPermission permission = await Geolocator.checkPermission();
                      if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
                          || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
                        if(GetPlatform.isAndroid) {
                          Get.dialog(ConfirmationDialog(
                            icon: Images.location_permission,
                            iconSize: 200,
                            hasCancel: false,
                            description: 'this_app_collects_location_data'.tr,
                            onYesPressed: () {
                              Get.back();
                              _checkPermission(() => authController.updateActiveStatus());
                            },
                          ), barrierDismissible: false);
                        }else {
                          _checkPermission(() => authController.updateActiveStatus());
                        }
                      }else {
                        authController.updateActiveStatus();
                      }
                    }
                  }
                },
              ) : SizedBox();
            });
          }),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          return await _loadData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: GetBuilder<AuthController>(builder: (authController) {

            return Column(children: [

              Container(
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)
                ),
                child: GetBuilder<OrderController>(builder: (orderController) {
                  bool _hasActiveOrder = orderController.currentOrderList == null || orderController.currentOrderList!.length > 0;
                  bool _hasMoreOrder = orderController.currentOrderList != null && orderController.currentOrderList!.length > 1;
                  return Column(children: [

                        Padding(padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: _hasActiveOrder ? TitleWidget(
                          size: 20,
                          title: 'active_order'.tr, onTap: _hasMoreOrder ? () {
                          Get.toNamed(RouteHelper.getRunningOrderRoute(), arguments: RunningOrderScreen());
                        } : null,
                        ) : SizedBox(),
                        ),


                    // SizedBox(height: _hasActiveOrder ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                    orderController.currentOrderList == null ? OrderShimmer(
                      isEnabled: orderController.currentOrderList == null,
                    ) : orderController.currentOrderList!.length > 0 ? OrderWidget(
                      orderModel: orderController.currentOrderList![0], isRunningOrder: true, orderIndex: 0,
                    ) : SizedBox(),
                  ]);
                }),
              ),

              (authController.profileModel != null && authController.profileModel?.earnings == 1) ? Column(children: [

                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                   // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      BigText(text: 'earnings'.tr,color: Colors.white,size: Dimensions.font26,),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                      Icon(Icons.account_balance_wallet_rounded, size:60, color: AppColors.yellowColor.withOpacity(0.8),),

                    ]),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      EarningWidget(
                        title: 'today'.tr,
                        amount: authController.profileModel != null ? authController.profileModel!.todaysEarning! : 0.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Container(height: 30, width: 1, color: Theme.of(context).cardColor),
                      ),

                      EarningWidget(
                        title: 'this_week'.tr,
                        amount: authController.profileModel != null ? authController.profileModel!.thisWeekEarning! : 0.0,
                      ),
                          Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Container(height: 30, width: 1, color: Theme.of(context).cardColor),
                          ),
                          EarningWidget(
                        title: 'this_month'.tr,
                        amount: authController.profileModel != null ? authController.profileModel!.thisMonthEarning! : 0.0,
                      ),
                    ]),
                  ]),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
              ]) : SizedBox(),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)
                ),
                child: Column(

                  children: [
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                        Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       BigText(text: 'orders'.tr,color: Colors.white,size: Dimensions.font26,),
                     ],
                   ),

                        CountCard(
                          title: 'todays_orders'.tr, backgroundColor:Colors.transparent, height: 40,
                          value: authController.profileModel != null ? authController.profileModel!.todaysOrderCount!.toString()! : "",
                        ),
                        CountCard(
                          title: 'this_week_orders'.tr, backgroundColor: Colors.transparent, height: 40,
                          value: authController.profileModel != null ? authController.profileModel!.thisWeekOrderCount
                              !.toString() : "",
                        ),
                        CountCard(
                      title: 'this_month'.tr, backgroundColor: Colors.transparent, height: 40,
                      value: authController.profileModel != null ? authController.profileModel!.orderCount!.toString() : "",
                    ),



                  ],
                ),
              ),





            ]);
          }),
        ),
      ),
    );
  }

  void _checkPermission(Function callback) async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied
        || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
      Get.dialog(CustomAlertDialog(description: 'you_denied'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.requestPermission();
        _checkPermission(callback);
      }), barrierDismissible: false);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(CustomAlertDialog(description: 'you_denied_forever'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.openAppSettings();
        _checkPermission(callback);
      }), barrierDismissible: false);
    }else {
      callback();
    }
  }
}
