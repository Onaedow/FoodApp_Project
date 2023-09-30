
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/base/custom_loader.dart';
import 'package:shopping_app/base/no_data_found.dart';
import 'package:shopping_app/controllers/order_controller.dart';
import 'package:shopping_app/models/order_model.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
import 'package:shopping_app/uitls/styles.dart';
import 'package:get/get.dart';

import 'order_shimmer.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  OrderView({required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OrderController>(builder: (orderController) {
      if(orderController.isLoading==false){
        late  List<OrderModel> orderList;
        if(orderController.runningOrderList.isNotEmpty) {
          orderList = isRunning ? orderController.runningOrderList.reversed.toList() : orderController.historyOrderList.reversed.toList();
        }else{
          orderList=[];
        }

        return orderList.isNotEmpty ?( orderList.length > 0 ?
        RefreshIndicator(
          onRefresh: () async {
            await orderController.getOrderList();
          },
          child: Scrollbar(child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH,
              child: ListView.builder(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                itemCount: orderList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {

                  return InkWell(
                    onTap: () {
                      //Get.toNamed(
                      // RouteHelper.getOrderDetailsRoute(orderList[index].id),
                      // arguments: OrderDetailsScreen(orderId: orderList[index].id, orderModel: orderList[index]),
                      // );
                    },
                    child: Container(

                      child: Column(children: [

                        Row(children: [

                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                Text('${'order_id'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Text('#${orderList[index].id}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              ]),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              /* Text(
                                DateConverter.dateTimeStringToDateTime(orderList[index].createdAt),
                                style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                              ),*/
                            ]),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(orderList[index].orderStatus!, style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor,
                              )),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            isRunning ? InkWell(
                              // onTap: () => Get.toNamed(RouteHelper.getOrderTrackingRoute(orderList[index].id)),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                  border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                ),
                                child: Row(children: [
                                  Image.asset("assets/image/tracking.png", height: 15, width: 15, color: Theme.of(context).primaryColor),
                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text('track_order'.tr, style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor,
                                  )),
                                ]),
                              ),
                            ) : Text(
                              '${orderList[index].detailsCount} ${orderList[index].detailsCount! > 1 ? 'items' : 'item'}',
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                            ),
                          ]),

                        ]),

                        (index == orderList.length-1) ? SizedBox() : Padding(
                          padding: EdgeInsets.only(left: 70),
                          child: Divider(
                            color: Theme.of(context).disabledColor, height: Dimensions.PADDING_SIZE_LARGE,
                          ),
                        ),

                      ]),
                    ),
                  );
                },
              ),
            )),
          )),
        ) :
        NoDataScreen(text: 'no_order_found'.tr) ):
        OrderShimmer(orderController: orderController);
      }else{
        return CustomLoader();
      }
      }),
    );
  }
}
