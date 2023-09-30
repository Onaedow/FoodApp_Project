import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/base/no_data_found.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/controllers/cart_controller.dart';
import 'package:shopping_app/models/cart_item.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/uitls/app_constants.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
import 'package:shopping_app/uitls/styles.dart';
import 'package:shopping_app/widgets/big_text.dart';
import 'package:shopping_app/widgets/text_widget.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
/*
we we have list of objects. First we find just get all the time
and then we find the unique time. At the same time we also find how
many times a certain time is found
 */
    var cartHistory=[];
    var originalHistory=[];
    originalHistory =  Get.find<CartController>().getCartHistory();
    Iterable inReverse = originalHistory.reversed;
    cartHistory = inReverse.toList();
    var listOfTime=[];
    for(int i=0; i<cartHistory.length; i++){
      listOfTime.add(cartHistory[i].time);
      print(cartHistory[i].img);
    }
    var cartItemsPerOrder = {};
    cartItemsPerOrder= Map<String, dynamic>();

    for(int i=0; i<cartHistory.length; i++){
      /*
      How many times a certain time is found in the list.
      The time number is used the wrap loop to show the itmes
      from a certain buy
       */
      if(cartItemsPerOrder.containsKey(cartHistory[i].time)){
        cartItemsPerOrder.update(cartHistory[i].time, (value) => ++value);
      }else{
        cartItemsPerOrder.putIfAbsent(cartHistory[i].time??DateTime.now().toString(), () => 1);
      }
    }
    /*
    returns list of int
     */
    List<dynamic> cartOrderTimeList(){
      return cartItemsPerOrder.entries.map((e){
        return e.value;
      }).toList();
    }
    List<dynamic> cartOrderTimeToList(){
      return cartItemsPerOrder.entries.map((e){
        return e.key;
      }).toList();
    }
    var xy=[];
    xy = cartOrderTimeList();
    var listCounter=0;
    Widget timeWidget(int index){
      var outputDate="";
      if(index<cartHistory.length){

        DateTime parseDate=  DateFormat("yyyy-MM-dd HH:mm:ss").parse(cartHistory[index].time!);
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat= DateFormat("MM/dd/yyyy hh:mm a");
         outputDate = outputFormat.format(inputDate);

      }
      return BigText(text:outputDate, color:AppColors.titleColor);
    }
    return  Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            width: double.maxFinite,
            padding: const EdgeInsets.only(top: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BigText(text:"Your cart history",
                    color: Colors.white,size:24),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(RouteHelper.getCartPage(0, "cart-history"));
                  },
                  child: Icon(Icons.shopping_cart_outlined, size:30, color:Colors.white),
                )
              ],
            ),

            decoration: BoxDecoration(
              color: AppColors.mainColor,

            ),
          ),
          GetBuilder<CartController>(builder: (_cartController){
            print("History length is "+_cartController.getCartHistory().length.toString());

            return _cartController.getCartHistory().length>0? Expanded(child:   Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                //height: double.maxFinite,

                child: MediaQuery.removePadding(context: context, removeTop: true,
                  child: ListView(
                    children: [
                      for(int index=0; index<xy.length; index++)

                        Container(
                          height: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Container(
                                height: 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    timeWidget(listCounter),
                                   /* ((){

                                      DateTime parseDate=  DateFormat("yyyy-MM-dd HH:mm:ss").parse(cartHistory[listCounter].time!);
                                      var inputDate = DateTime.parse(parseDate.toString());
                                      var outputFormat= DateFormat("MM/dd/yyyy hh:mm a");
                                      var outputDate = outputFormat.format(inputDate);
                                      return BigText(text:outputDate, color:AppColors.titleColor);*/
                                   // }()
                                   // ),*/
                                    Wrap(
                                        direction: Axis.horizontal,

                                        children: List.generate(xy[index], (index1) {
                                          if(listCounter<cartHistory.length) {
                                            listCounter++;
                                          }
                                          if (index1 <= 2) {

                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10, bottom: 20, top: 5),
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(8),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        /*
                                saveCounter is actually the same as the
                                items in the original list of cart history
                                 */
                                                          AppConstants
                                                              .UPLOADS_URL +
                                                              cartHistory[listCounter -
                                                                  1].img
                                                      )
                                                  )
                                              ),
                                            );
                                          } else{
                                            return Container();
                                          }

                                        })
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                height: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextWidget(text: "Total", color: AppColors.mainBlackColor),
                                    BigText(text:xy[index].toString()+" Items", color:AppColors.titleColor),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,
                                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                      ),
                                      child: Row(children: [
                                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        GestureDetector(

                                          onTap: (){

                                            var orderTime = cartOrderTimeToList();
                                            Map<int, CartItem> moreOrder ={};
                                            for(int j=0; j<cartHistory.length; j++){
                                              if(cartHistory[j].time==orderTime[index]){
                                                print(orderTime[index]+" J is "+j.toString());
                                                print(jsonEncode(cartHistory[j]));
                                                moreOrder.putIfAbsent(int.parse(cartHistory[j].id), () =>
                                                    CartItem.fromJson(jsonDecode(jsonEncode(cartHistory[j]))));
                                              }
                                            }
                                            Get.find<CartController>().setItems=moreOrder;
                                            Get.find<CartController>().addToCartList();
                                            Get.toNamed(RouteHelper.getCartPage(0, "cart-history"));
                                          },
                                          child: Text("one more", style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor,
                                          )),
                                        ),
                                      ]),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )

                    ],
                  ),)
            )):Center(
              child: NoDataScreen(text: "No history "),
            );
          })
    ]));
  }
}

