import 'package:the_best_food/data/model/response/order_model.dart';
import 'package:the_best_food/helper/route_helper.dart';
import 'package:the_best_food/util/colors.dart';
import 'package:the_best_food/util/dimensions.dart';
import 'package:the_best_food/util/images.dart';
import 'package:the_best_food/util/styles.dart';
import 'package:the_best_food/view/base/custom_button.dart';
import 'package:the_best_food/view/base/custom_snackbar.dart';
import 'package:the_best_food/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool isRunningOrder;
  final int orderIndex;
  OrderWidget({required this.orderModel, required this.isRunningOrder, required this.orderIndex});

  @override
  Widget build(BuildContext context) {
    return Container(

     // margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
       // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
      ),
      child: Column(children: [

        Row(children: [
          Text('${'order_id'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white)),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text('#${orderModel.id}', style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white)),
          Expanded(child: SizedBox()),
          Container(
            width: 16, height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
            ),
            child: Center(
              child: Container(width: 12, height: 12, decoration: BoxDecoration(
                color: orderModel.paymentMethod == 'cash_on_delivery' ? Colors.red : Colors.green,
                shape: BoxShape.circle,
              )),
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL*2),
          Text(
            orderModel.paymentMethod == 'cash_on_delivery' ? 'cod'.tr : 'digitally_paid'.tr,
            style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white),
          ),
        ]),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
          Icon(orderModel.orderStatus == 'picked_up' ? Icons.person : Icons.house_outlined, size:20, color: Colors.white,),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text(
            orderModel.orderStatus == 'picked_up' ? 'customer_location'.tr :'restaurant_location'.tr,
            style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ]),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
          Icon(Icons.location_on, size: 20, color: Colors.white,),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Expanded(child: Text(
            orderModel.deliveryAddress!.address.toString(),
            style: robotoRegular.copyWith( fontSize: Dimensions.FONT_SIZE_SMALL,color: Colors.white),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          )),
        ]),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        Row(children: [
          Expanded(child: TextButton(
            onPressed: () {
              Get.toNamed(
                RouteHelper.getOrderDetailsRoute(orderModel.id??0),
                arguments: OrderDetailsScreen(orderModel: orderModel, isRunningOrder: isRunningOrder, orderIndex: orderIndex),
              );
            },
            style: TextButton.styleFrom(minimumSize: Size(1170, 45), padding: EdgeInsets.zero, shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), side: BorderSide(width: 2, color: AppColors.yellowColor),
            )),
            child: Text('details'.tr, textAlign: TextAlign.center, style: robotoBold.copyWith(
              color: Colors.white, fontSize: Dimensions.FONT_SIZE_LARGE,
            )),
          )),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(child:
              TextButton(
                onPressed:     () async {
                  String _url;
                  if(orderModel.orderStatus == 'picked_up') {
                    _url = 'https://www.google.com/maps/dir/?api=1&destination=${orderModel.deliveryAddress!.latitude}'
                        ',${orderModel.deliveryAddress!.longitude}&mode=d';
                  }else {
                    _url = 'https://www.google.com/maps/dir/?api=1&destination=${orderModel.restaurantLat}'
                        ',${orderModel.restaurantLng}&mode=d';
                  }
                  if (await canLaunch(_url)) {
                    await launch(_url);
                  } else {
                    showCustomSnackBar('${'could_not_launch'.tr} $_url');
                  }
                },
                style: TextButton.styleFrom(minimumSize: Size(1170, 45), padding: EdgeInsets.zero, shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), side: BorderSide(width: 2, color: AppColors.yellowColor),
                )),
                child: Text('direction'.tr, textAlign: TextAlign.center, style: robotoBold.copyWith(
                  color: Colors.white, fontSize: Dimensions.FONT_SIZE_LARGE,
                )),
              )
          ),
        ]),

      ]),
    );
  }
}
