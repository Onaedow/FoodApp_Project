import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/components/expanded_widget.dart';
import 'package:shopping_app/controllers/cart_controller.dart';
import 'package:shopping_app/controllers/popular_product.dart';
import 'package:shopping_app/controllers/product_controller.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/uitls/app_constants.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
import 'package:shopping_app/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:shopping_app/widgets/text_widget.dart';

class MoreFood extends StatelessWidget {
  int pageId;
  String page;

  MoreFood({
    Key? key,
    required this.pageId,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productItem = Get.find<PopularProduct>().popularProductList[pageId];
    Get.find<ProductController>()
        .initData(productItem, pageId, Get.find<CartController>());

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(20),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 5, top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  width: double.maxFinite,
                  child: Center(
                    child: BigText(
                        text: productItem.title,
                        color: AppColors.mainBlackColor),
                  ),
                ),
              ),
              //without this we see an arrow
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.yellowColor,
              //without this the top bar is very thin
              //it starts from bottom
              toolbarHeight: 90,
              floating: false,
              //stick top
              pinned: true,
              expandedHeight: 300,
              leadingWidth: 50,
              titleSpacing: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 25),
                background: CachedNetworkImage(
                  imageUrl:  AppConstants.UPLOADS_URL + productItem.img,
                  imageBuilder: (context, imageProvider) => Container(
                    width: double.maxFinite,
                    height: Dimensions.moreViewCon,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        //image size fill
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    child:
                        CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
                  ), //show progress  while loading image
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/image/icon.png"),
                  //show no image available image on error loading
                ),
                /*Image.network(
                AppConstants.UPLOADS_URL + productItem.img,
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: Dimensions.moreViewCon,
              ),*/
                //titlePadding: EdgeInsets.all(16),

                title: Row(
                  children: [
                    Container(
                      // margin: EdgeInsets.only(left:GetPlatform.isIOS?10:0),
                      width: 30,
                      height: 30,
                      child: GestureDetector(
                          onTap: () {
                            //Get.offNamed(RouteHelper.getInitialRoute());
                            Get.back();
                          },
                          child: Center(
                              child: TextWidget(
                            text: "X",
                            color: Colors.black54,
                          ))),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 5),
                                blurRadius: 5,
                                color: Colors.grey.withOpacity(0.1))
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                    ),
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getCartPage(pageId, page));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white70,
                        ),
                        child: GetBuilder<CartController>(builder: (_) {
                          return Stack(
                            children: [
                              Positioned(
                                child: Center(
                                    child: Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 16,
                                  color: Colors.black54,
                                )),
                              ),
                              Get.find<CartController>().totalItems >= 1
                                  ? Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Center(
                                          child: Icon(
                                        Icons.circle,
                                        size: 16,
                                        color: AppColors.mainColor,
                                      )),
                                    )
                                  : Container(),
                              Get.find<CartController>().totalItems > 1
                                  ? Positioned(
                                      right: 4,
                                      top: 3,
                                      child: Center(
                                          child: Text(
                                        Get.find<CartController>()
                                            .totalItems
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      )),
                                    )
                                  : Container()
                            ],
                          );
                        }),
                      ),
                    )
                  ],
                ),
              )),
          SliverToBoxAdapter(
            child: Column(
              children: [
                //SizedBox(height: 10,),
                Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child:
                        DescriptionTextWidget(text: productItem.description)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.find<ProductController>().setQuantity(false, productItem);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Icon(Icons.remove, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 5),
                            blurRadius: 5,
                            color: Colors.grey.withOpacity(0.1))
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor),
                ),
              ),
              SizedBox(width: 40),
              GetBuilder<ProductController>(builder: (_) {
                return BigText(
                  text: "\$12.88 " +
                      " X " +
                      Get.find<ProductController>().certainItems.toString(),
                  color: AppColors.mainBlackColor,
                  size: 26,
                );
              }),
              SizedBox(width: 40),
              GestureDetector(
                onTap: () {
                  Get.find<ProductController>().setQuantity(true, productItem);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 5),
                            blurRadius: 5,
                            color: Colors.grey.withOpacity(0.1))
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(
                left: Dimensions.detailFoodImgPad,
                right: Dimensions.detailFoodImgPad),
            height: Dimensions.buttomButton,
            padding: EdgeInsets.only(
                top: Dimensions.padding20,
                bottom: Dimensions.padding20,
                left: Dimensions.padding20,
                right: Dimensions.padding20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.padding20),
                  child: Icon(
                    Icons.favorite,
                    color: AppColors.mainColor,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.padding20),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            //spreadRadius: 3,
                            color: AppColors.titleColor.withOpacity(0.05))
                      ]),
                ),
                Expanded(child: Container()),
                GetBuilder<ProductController>(builder: (_) {
                  return Container(
                    child: GestureDetector(
                      onTap: () {
                        Get.find<ProductController>().addItem(productItem);
                      },
                      child: BigText(
                        text: "\$ 28 | " + "add_to_cart".tr,
                        color: Colors.white,
                      ),
                    ),
                    padding: EdgeInsets.all(Dimensions.padding20),
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.padding20),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 5),
                              blurRadius: 10,
                              //spreadRadius: 3,
                              color: AppColors.mainColor.withOpacity(0.3))
                        ]),
                  );
                })
              ],
            ),
            decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.padding40),
                  topRight: Radius.circular(Dimensions.padding40),
                )),
          )
        ],
      ),
    );
  }
}
