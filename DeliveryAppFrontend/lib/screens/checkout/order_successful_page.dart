
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/screens/checkout/payment_failed_dialogue.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';

import '../../base/custom_button.dart';
import 'package:get/get.dart';

import '../../routes/route_helper.dart';
import '../../uitls/styles.dart';
class OrderSuccessfulScreen extends StatelessWidget {
  final String orderID;
  final int status;
  OrderSuccessfulScreen({required this.orderID, required this.status});

  @override
  Widget build(BuildContext context) {
    if(status == 0) {
      Future.delayed(Duration(seconds: 1), () {
        Get.dialog(PaymentFailedDialog(orderID: orderID), barrierDismissible: false);
      });
    }
    return Scaffold(

      body: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child:
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(

            status==1? Icons.check_circle_outline:Icons.warning_amber_outlined,
          size:100.0,
          color: AppColors.mainColor,
        ),

        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

        Text(
          status == 1 ? 'you_placed_the_order_successfully'.tr : 'your_order_is_failed_to_place'.tr,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,
              vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Text(
            status == 1 ? 'order_successful'.tr : 'order_failed'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).disabledColor),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30),

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: CustomButton(buttonText: 'back_to_home'.tr, onPressed:
              () => Get.offAllNamed(RouteHelper.getInitialRoute())),
        ),
      ]))),
    );
  }
}
