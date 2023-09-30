import 'dart:async';

import 'package:the_best_food/controller/order_controller.dart';
import 'package:the_best_food/util/dimensions.dart';
import 'package:the_best_food/view/base/custom_app_bar.dart';
import 'package:the_best_food/view/screens/request/widget/order_requset_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderRequestScreen extends StatefulWidget {
  void Function()? onTap;
  OrderRequestScreen({required this.onTap});

  @override
  _OrderRequestScreenState createState() => _OrderRequestScreenState();
}

class _OrderRequestScreenState extends State<OrderRequestScreen> {
  Timer? _timer;

  @override
  initState() {
    super.initState();

    Get.find<OrderController>().getLatestOrders();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      Get.find<OrderController>().getLatestOrders();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'order_request'.tr, isBackButtonExist: false, ),
      body: GetBuilder<OrderController>(builder: (orderController) {
        return orderController.latestOrderList != null ? orderController.latestOrderList!.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await Get.find<OrderController>().getLatestOrders();
          },
          child: ListView.builder(
            itemCount: orderController.latestOrderList!.length,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return OrderRequestWidget(orderModel: orderController.latestOrderList![index], index: index, onTap: widget.onTap!);
            },
          ),
        ) : Center(child: Text('no_order_request_available'.tr)) : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
