import 'package:the_best_food/controller/auth_controller.dart';
import 'package:the_best_food/controller/localization_controller.dart';
import 'package:the_best_food/controller/order_controller.dart';
import 'package:the_best_food/controller/splash_controller.dart';
import 'package:the_best_food/data/model/response/order_model.dart';
import 'package:the_best_food/util/dimensions.dart';
import 'package:the_best_food/util/images.dart';
import 'package:the_best_food/util/styles.dart';
import 'package:the_best_food/view/base/confirmation_dialog.dart';
import 'package:the_best_food/view/base/custom_app_bar.dart';
import 'package:the_best_food/view/base/custom_button.dart';
import 'package:the_best_food/view/base/custom_snackbar.dart';
import 'package:the_best_food/view/screens/order/widget/order_product_widget.dart';
import 'package:the_best_food/view/screens/order/widget/verify_delivery_sheet.dart';
import 'package:the_best_food/view/screens/order/widget/info_card.dart';
import 'package:the_best_food/view/screens/order/widget/slider_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel orderModel;
  final bool isRunningOrder;
  final int orderIndex;
  OrderDetailsScreen({required this.orderModel, required this.isRunningOrder, required this.orderIndex});

  @override
  Widget build(BuildContext context) {
    bool _cancelPermission = Get.find<SplashController>().configModel.canceledByDeliveryman!;
    bool _selfDelivery = Get.find<AuthController>().profileModel?.type != 'zone_wise';
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      Get.find<OrderController>().getCurrentOrders();
      String _type = message.data['type'];
      if(isRunningOrder && _type == 'order_status') {
        Get.back();
      }
    });
    Get.find<OrderController>().getOrderDetails(orderModel.id??0);
    bool _restConfModel = Get.find<SplashController>().configModel.orderConfirmationModel != 'deliveryman';
    bool _showBottomView = orderModel.orderStatus == 'accepted' || orderModel.orderStatus == 'confirmed'
        || orderModel.orderStatus == 'processing' || orderModel.orderStatus == 'handover'
        || orderModel.orderStatus == 'picked_up' || isRunningOrder;
    bool _showSlider = (orderModel.paymentMethod == 'cash_on_delivery' && orderModel.orderStatus == 'accepted' && !_restConfModel && !_selfDelivery)
        || orderModel.orderStatus == 'handover' || orderModel.orderStatus == 'picked_up';

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(title: 'order_details'.tr,),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: GetBuilder<OrderController>(builder: (orderController) {
          return orderController.orderDetailsModel != null ? Column(children: [

            Expanded(child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(children: [

                Row(children: [
                  Text('${'order_id'.tr}:', style: robotoRegular),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(orderModel.id.toString(), style: robotoMedium),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Expanded(child: SizedBox()),
                  Container(height: 7, width: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                    orderModel.orderStatus!.tr,
                    style: robotoRegular,
                  ),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                /*InfoCard(
                  title: 'restaurant_details'.tr, address: orderModel.restaurantAddress,
                  image: '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${orderModel.restaurantLogo}',
                  name: orderModel.restaurantName, phone: orderModel.restaurantPhone,
                  latitude: orderModel.restaurantLat, longitude: orderModel.restaurantLng,
                  showButton: orderModel.orderStatus != 'delivered',
                ),*/
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

               /* InfoCard(
                  title: 'customer_contact_details'.tr, address: orderModel.deliveryAddress.address,
                  image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}/${orderModel.customer.image}',
                  name: orderModel.deliveryAddress.contactPersonName, phone: orderModel.deliveryAddress.contactPersonNumber,
                  latitude: orderModel.deliveryAddress.latitude, longitude: orderModel.deliveryAddress.longitude,
                  showButton: orderModel.orderStatus != 'delivered',
                ),*/
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Row(children: [
                      Text('${'item'.tr}:', style: robotoRegular),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(
                        orderController.orderDetailsModel!.length.toString(),
                        style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          orderModel.paymentMethod == 'cash_on_delivery' ? 'cod'.tr : orderModel.paymentMethod == 'wallet'
                              ? 'wallet_payment'.tr : 'digitally_paid'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).cardColor),
                        ),
                      ),
                    ]),
                  ),
                  Divider(height: Dimensions.PADDING_SIZE_LARGE),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderController.orderDetailsModel!.length,
                    itemBuilder: (context, index) {
                      return OrderProductWidget(order: orderModel, orderDetails: orderController.orderDetailsModel![index]);
                    },
                  ),

                  (orderModel.orderNote  != null && orderModel.orderNote!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('additional_note'.tr, style: robotoRegular),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Container(
                      width: 1170,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: Theme.of(context).disabledColor),
                      ),
                      child: Text(
                        orderModel.orderNote!,
                        style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  ]) : SizedBox(),

                ]),

              ]),
            )),

            _showBottomView ? ((orderModel.orderStatus == 'accepted' && (orderModel.paymentMethod != 'cash_on_delivery'))
             || orderModel.orderStatus == 'processing' || orderModel.orderStatus == 'confirmed') ? Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                border: Border.all(width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                orderModel.orderStatus == 'processing' ? 'food_is_preparing'.tr : 'food_waiting_for_cook'.tr,
                style: robotoMedium,
              ),
            ) :
            _showSlider ? (orderModel.paymentMethod == 'cash_on_delivery' && orderModel.orderStatus == 'accepted'
             && _cancelPermission ) ? Row(children: [
              Expanded(child: TextButton(
                onPressed: () => Get.dialog(ConfirmationDialog(
                  icon: Images.warning, title: 'are_you_sure_to_cancel'.tr, description: 'you_want_to_cancel_this_order'.tr,
                  onYesPressed: () {
                    orderController.updateOrderStatus(orderIndex, 'canceled', back: true).then((success) {
                      if(success) {
                        Get.find<AuthController>().getProfile();
                        Get.find<OrderController>().getCurrentOrders();
                      }
                    });
                  },
                ), barrierDismissible: false),
                style: TextButton.styleFrom(
                  minimumSize: Size(1170, 40), padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    side: BorderSide(width: 1, color: Theme.of(context).textTheme.bodyText1!.color!),
                  ),
                ),
                child: Text('cancel'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                )),
              )),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(child: CustomButton(
                buttonText: 'confirm'.tr, height: 40,
                onPressed: () {
                  Get.dialog(ConfirmationDialog(
                    icon: Images.warning, title: 'are_you_sure_to_confirm'.tr, description: 'you_want_to_confirm_this_order'.tr,
                    onYesPressed: () {
                      orderController.updateOrderStatus(orderIndex, 'confirmed', back: true).then((success) {
                        if(success) {
                          Get.find<AuthController>().getProfile();
                          Get.find<OrderController>().getCurrentOrders();
                        }
                      });
                    },
                  ), barrierDismissible: false);
                },
              )),
            ]) : SliderButton(
              action: () {
                if(orderModel.paymentMethod == 'cash_on_delivery' && orderModel.orderStatus == 'accepted') {
                  Get.dialog(ConfirmationDialog(
                    icon: Images.warning, title: 'are_you_sure_to_confirm'.tr, description: 'you_want_to_confirm_this_order'.tr,
                    onYesPressed: () {
                      orderController.updateOrderStatus(orderIndex, 'confirmed', back: true).then((success) {
                        if(success) {
                          Get.find<AuthController>().getProfile();
                          Get.find<OrderController>().getCurrentOrders();
                        }
                      });
                    },
                  ), barrierDismissible: false);
                }else if(orderModel.orderStatus == 'picked_up') {
                  if(Get.find<SplashController>().configModel.orderDeliveryVerification!
                      || orderModel.paymentMethod == 'cash_on_delivery') {
                    print("here0...");
                    Get.bottomSheet(VerifyDeliverySheet(
                      orderIndex: orderIndex, verify: Get.find<SplashController>().configModel.orderDeliveryVerification!,
                      orderAmount: orderModel.orderAmount!, cod: orderModel.paymentMethod == 'cash_on_delivery',
                    ), isScrollControlled: true);
                  }else {
                    Get.find<OrderController>().updateOrderStatus(orderIndex, 'delivered').then((success) {
                      if(success) {
                        print("here...");
                        Get.find<AuthController>().getProfile();
                        Get.find<OrderController>().getCurrentOrders();
                      }
                    });
                  }
                }else if(orderModel.orderStatus == 'handover') {
                  if(Get.find<AuthController>().profileModel!.active == 1) {
                    Get.find<OrderController>().updateOrderStatus(orderIndex, 'picked_up').then((success) {
                      if(success) {
                        Get.find<AuthController>().getProfile();
                        Get.find<OrderController>().getCurrentOrders();
                      }
                    });
                  }else {
                    showCustomSnackBar('make_yourself_online_first'.tr);
                  }
                }
              },
              label: Text(
                (orderModel.paymentMethod == 'cash_on_delivery' && orderModel.orderStatus == 'accepted')
                    ? 'swipe_to_confirm_order'.tr : orderModel.orderStatus == 'picked_up' ? 'swipe_to_deliver_order'.tr
                    : orderModel.orderStatus == 'handover' ? 'swipe_to_pick_up_order'.tr : '',
                style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).primaryColor),
              ),
              dismissThresholds: 0.5, dismissible: false, shimmer: true,
              width: 1170, height: 60, buttonSize: 50, radius: 10,
              icon: Center(child: Icon(
                Get.find<LocalizationController>().isLtr ? Icons.double_arrow_sharp : Icons.keyboard_arrow_left,
                color: Colors.white, size: 20.0,
              )),
              isLtr: Get.find<LocalizationController>().isLtr,
              boxShadow: BoxShadow(blurRadius: 0),
              buttonColor: Theme.of(context).primaryColor,
              backgroundColor: Color(0xffF4F7FC),
              baseColor: Theme.of(context).primaryColor,
            ) : SizedBox() : SizedBox(),

          ]) : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
