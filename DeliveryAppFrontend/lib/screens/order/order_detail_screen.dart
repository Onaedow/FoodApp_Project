import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/components/colors.dart';
import '../../base/confirm_dialogue.dart';
import '../../base/custom_button.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/splash_controller.dart';
import '../../helper/app_date_converter.dart';
import '../../models/order_detail_model.dart';
import '../../models/order_model.dart';
import '../../routes/route_helper.dart';
import '../../uitls/app_dimensions.dart';
import '../../uitls/images.dart';
import '../../uitls/styles.dart';
import 'package:get/get.dart';
class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final int orderId;
  OrderDetailsScreen({required this.orderModel, required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late StreamSubscription _stream;

  void _loadData(BuildContext context, bool reload) async {
    await Get.find<OrderController>().trackOrder(widget.orderId.toString(), reload ? null : widget.orderModel, false);
    if(widget.orderModel == null) {
      await Get.find<SplashController>().getConfigData();
    }
    print("my order id is "+widget.orderId.toString());
    Get.find<OrderController>().getOrderDetails(widget.orderId.toString());
  }

  @override
  void initState() {
    super.initState();

    _stream = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage on Details: ${message.data}");
      _loadData(context, true);
    });

    _loadData(context, false);
  }

  @override
  void dispose() {
    super.dispose();

    _stream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(widget.orderModel == null) {
         // return Get.offAllNamed(RouteHelper.getInitial());
          return true;
        }else {
          return true;
        }
      },
      child: Scaffold(
        appBar: /*CustomAppBar(title: 'order_details'.tr, onBackPressed: () {
          if(widget.orderModel == null) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          }else {
            Get.back();
          }
        }),*/
        AppBar(
          backgroundColor: AppColors.mainColor,
          title: Text("order_details".tr),
        ),
        body: GetBuilder<OrderController>(builder: (orderController) {
          double _deliveryCharge = 0;
          double _itemsPrice = 0;
          double _discount = 0;
          double _couponDiscount = 0;
          double _tax = 0;
          double _addOns = 0;
          OrderModel? _order = orderController.trackModel;

          double _subTotal = _itemsPrice + _addOns;
          for(OrderDetailsModel orderDetails in orderController.orderDetails) {

            _itemsPrice = _itemsPrice + (orderDetails.price * orderDetails.quantity);
          }
          double _total = _itemsPrice + _addOns - _discount + _tax + _deliveryCharge - _couponDiscount;

          return orderController.orderDetails.isNotEmpty ? Column(children: [

            Expanded(child: Scrollbar(child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${'order_id'.tr}:', style: robotoRegular),

                      Text(_order!.id.toString(), style: robotoMedium),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.timer, size: 20, color: AppColors.yellowColor,),

                      Text(
                        DateConverter.dateTimeStringToDateTime(_order.createdAt!),
                        style: robotoMedium,
                      ),
                    ],
                  ),

                SizedBox(height: Dimensions.height10,),

                _order.scheduled == 1 ? Row(children: [
                  Text('${'scheduled_at'.tr}:', style: robotoRegular),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(DateConverter.dateTimeStringToDateTime(_order.scheduleAt!), style: robotoMedium),
                ]) : SizedBox(),
                Divider(height: Dimensions.PADDING_SIZE_LARGE),
                SizedBox(height: _order.scheduled == 1 ? Dimensions.PADDING_SIZE_SMALL : 0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("order_type".tr, style: robotoRegular),
                      Text(_order.orderType!.tr, style: robotoMedium),

                    ],
                  ),
                SizedBox(height: Dimensions.height10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("payment_status".tr, style: robotoRegular,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        ),
                        child: Text(
                          _order.paymentMethod == 'cash_on_delivery' ? 'cash_on_delivery'.tr : _order.paymentMethod == 'wallet'
                              ? 'wallet_payment'.tr : 'digital_payment'.tr,
                          style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeExtraSmall),
                        ),
                      )
                    ],
                  ),

                Divider(height: Dimensions.PADDING_SIZE_LARGE),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Row(
                      children: [
                        Text('${'item'.tr}:', style: robotoRegular),
                        SizedBox(width: Dimensions.height10,),
                        Text(
                          orderController.orderDetails.length.toString(),
                          style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Container(height: 7, width: 7, decoration: BoxDecoration(
                          color: (_order.orderStatus == 'failed' || _order.orderStatus == 'refunded') ? Colors.red : Colors.green,
                          shape: BoxShape.circle,
                        )),
                        SizedBox(width: Dimensions.height10,),
                        Text(
                          _order.orderStatus == 'delivered' ? '${'delivered_at'.tr} ${DateConverter.dateTimeStringToDateTime(_order.delivered!)}'
                              : _order.orderStatus!.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                      ],
                    )
                  ]),
                ),
                Divider(height: Dimensions.PADDING_SIZE_LARGE),
                SizedBox(height: Dimensions.height10,),

                (_order.orderNote  != null && _order.orderNote!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('additional_note'.tr, style: robotoRegular),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  Container(
                    width: Dimensions.WEB_MAX_WIDTH,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      border: Border.all(width: 1, color: Theme.of(context).disabledColor),
                    ),
                    child: Text(
                      _order.orderNote!,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                ]) : SizedBox(),

                // Total
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('item_price'.tr, style: robotoRegular),
                  Text(_itemsPrice.toString(), style: robotoRegular),
                ]),
                SizedBox(height: 10),

                SizedBox(height: 10),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('delivery_fee'.tr, style: robotoRegular),
                  _deliveryCharge > 0 ? Text(
                    '(+) ${_deliveryCharge}', style: robotoRegular,
                  ) : Text('free'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
                ]),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                  child: Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
                ),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('total_amount'.tr, style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor,
                  )),
                  Text(
                    _total.toString(),
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                  ),
                ]),

              ]))),
            ))),

            !orderController.showCancelled ? Center(
              child: SizedBox(
                width: Dimensions.WEB_MAX_WIDTH,
                child: Row(children: [
                  (_order.orderStatus == 'pending' || _order.orderStatus == 'accepted' || _order.orderStatus == 'confirmed'
                      || _order.orderStatus == 'processing' || _order.orderStatus == 'handover'|| _order.orderStatus == 'picked_up') ? Expanded(
                    child: CustomButton(
                      buttonText: 'track_order'.tr,
                      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      onPressed: () {
                      //  Get.toNamed(RouteHelper.getOrderTrackingRoute(_order.id));
                      },
                    ),
                  ) : SizedBox(),
                  _order.orderStatus == 'pending' ? Expanded(child: Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: TextButton(
                      style: TextButton.styleFrom(minimumSize: Size(1, 50), backgroundColor: AppColors.yellowColor, shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),

                      )),
                      onPressed: () {
                        Get.dialog(ConfirmationDialog(
                          icon: Images.warning, description: 'are_you_sure_to_cancel'.tr, onYesPressed: () {
                          orderController.cancelOrder(_order.id);
                        },
                        ));
                      },
                      child: Text('cancel_order'.tr, style: robotoBold.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.fontSizeLarge,
                      )),
                    ),
                  )) : SizedBox(),

                ]),
              ),
            ) : Center(
              child: Container(
                width: Dimensions.WEB_MAX_WIDTH,
                height: 50,
                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.yellowColor,

                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                child: Text('order_cancelled'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
              ),
            ),



            (_order.orderStatus == 'failed' && Get.find<SplashController>().configModel?.cashOnDelivery!=null) ? Center(
              child: Container(
                width: Dimensions.WEB_MAX_WIDTH,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: CustomButton(
                  buttonText: 'switch_to_cash_on_delivery'.tr,
                  onPressed: () {
                    Get.dialog(ConfirmationDialog(
                        icon: Images.warning, description: 'are_you_sure_to_switch'.tr,
                        onYesPressed: () {

                        }
                    ));
                  },
                ),
              ),
            ) : SizedBox(),

          ]) : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}