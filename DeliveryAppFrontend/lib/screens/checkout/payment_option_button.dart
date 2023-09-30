
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/order_controller.dart';
import '../../uitls/app_dimensions.dart';
import '../../uitls/styles.dart';
class PaymentOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int index;
  PaymentOptionButton({required this.index, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<OrderController>(builder: (orderController) {
      bool _selected = orderController.paymentMethodIndex == index;
      return Padding(
        padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        child: InkWell(
          onTap: () => orderController.setPaymentMethod(index),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)],
            ),
            child: ListTile(
              leading: Icon(
                icon,
                size:40,
                color: _selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
              ),

              title: Text(
                title,
                style: robotoMedium.copyWith(fontSize: Dimensions.font20),
              ),
              subtitle: Text(
                subtitle,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              trailing: _selected ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor) : null,
            ),
          ),
        ),
      );
    });
  }
}
