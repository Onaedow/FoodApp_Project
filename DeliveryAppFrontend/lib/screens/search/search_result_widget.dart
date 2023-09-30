
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/search/widget/item_view.dart';

import '../../base/custom_snackbar.dart';
import '../../components/colors.dart';
import '../../components/expanded_widget.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/popular_product.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/search_product_controller.dart';
import 'package:get/get.dart';

import '../../routes/route_helper.dart';
import '../../uitls/app_constants.dart';
import '../../uitls/app_dimensions.dart';
import '../../uitls/styles.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_text_widget.dart';
import '../../widgets/text_widget.dart';
class SearchResultWidget extends StatefulWidget {
  final String searchText;
  SearchResultWidget({required this.searchText});

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

   // _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        GetBuilder<SearchProductController>(builder: (searchController) {
          bool _isNull = true;
          int _length = 0;

          _isNull = searchController.searchProductList == null;
          if(!_isNull) {
            _length = searchController.searchProductList!.length;
          }

          return _isNull ? SizedBox() : Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Row(children: [
              Text(
                _length.toString(),
                style: robotoBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Text(
                'results found',
                style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
              ),
            ]),
          )));
        }),

        /* Center(child: Container(
        width: Dimensions.WEB_MAX_WIDTH,
        color: Theme.of(context).cardColor,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).disabledColor,
          unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
          labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
          tabs: [
            Tab(text: 'food'),

          ],
        ),
      )),*/

        Expanded(child: NotificationListener(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              //Get.find<SearchProductController>().setRestaurant(_tabController.index == 1);
              Get.find<SearchProductController>().searchData(widget.searchText);
            }
            return false;
          },
          child: Container(

            child: GetBuilder<SearchProductController>(builder: (searchController) {
              return InkWell(
                onTap: (){


                },
                child: SingleChildScrollView(
                  child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding:  EdgeInsets.only(top: Dimensions.padding10),
                    itemCount: searchController.searchProductList?.length,
                    itemBuilder: (context, index) {

                      return GestureDetector(
                          onTap: (){

                            bool found=false;
                            String page="initial";
                            late List tempList=[];
                             int productIndex=0;
                            tempList = Get.find<ProductController>().popularProductList;
                            tempList.forEach((element) {
                              if(element.id.toString()==searchController.searchProductList?[index].id.toString()){
                                found=true;
                                productIndex++;
                                page="popular";
                              }else{
                                productIndex++;
                              }
                            });
                            if(found==false){
                              productIndex=0;
                              tempList=[];
                              tempList=Get.find<PopularProduct>().popularProductList;
                              tempList.forEach((element) {
                                if(element.id.toString()==searchController.searchProductList?[index].id.toString()){
                                  found=true;
                                  page="recommended";
                                  productIndex++;
                                }else{
                                  productIndex++;
                                }
                              });
                            }
                            var product = searchController.searchProductList![index];
                            Get.find<ProductController>().initData(product, productIndex, Get.find<CartController>());
                            showModalBottomSheet(context: context,
                                // backgroundColor: Colors.white,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (_){
                                  return Container(
                                    height: MediaQuery.of(context).size.height * 0.75,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(25.0),
                                        topRight: const Radius.circular(25.0),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: 6),
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.white70,
                                              ),
                                              child: GestureDetector(
                                                onTap: (){
                                                  // Get.toNamed(RouteHelper.getInitialRoute());
                                                  Get.back();
                                                },
                                                child: Center(
                                                    child: Icon(
                                                      Icons.arrow_back_ios,
                                                      size: 16,
                                                      color: Colors.black54,
                                                    )),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                  Get.toNamed(RouteHelper.getCartPage(productIndex, page));
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(left: 0),
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.white70,
                                                ),
                                                child: GetBuilder<CartController>(builder:(_){
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
                                                      Get.find<CartController>().totalItems>=1?Positioned(
                                                        right: 5,
                                                        top:5,
                                                        child: Center(
                                                            child: Icon(
                                                              Icons.circle,
                                                              size: 16,
                                                              color: AppColors.mainColor,
                                                            )),
                                                      ):Container(),
                                                      Get.find<CartController>().totalItems>1?Positioned(
                                                        right: 8,
                                                        top:6,
                                                        child: Center(
                                                            child:  Text(
                                                              Get.find<CartController>().totalItems.toString(),
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors.white
                                                              ),
                                                            )
                                                        ),
                                                      ):Container()
                                                    ],
                                                  );
                                                }),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 430,

                                          padding: const EdgeInsets.only(left: 20, right: 20, top:20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(Dimensions.padding20),
                                                  topLeft: Radius.circular(Dimensions.padding20))),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              BigText(
                                                  size: Dimensions.font26,
                                                  text: product.title,
                                                  color: Colors.black87),
                                              SizedBox(
                                                height: Dimensions.padding10,
                                              ),
                                              Row(
                                                children: [
                                                  Wrap(
                                                    children: List.generate(
                                                        5,
                                                            (index) => Icon(Icons.star,
                                                            color: AppColors.mainColor, size: 15)),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  TextWidget(text: "4.5", color: Color(0xFFccc7c5)),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  TextWidget(
                                                      text: "1287"+" "+"comments".tr, color: Color(0xFFccc7c5))
                                                ],
                                              ),
                                              SizedBox(
                                                height: Dimensions.padding20,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  IconAndTextWidget(
                                                    text: "Normal",
                                                    color: AppColors.textColor,
                                                    icon: Icons.circle_sharp,
                                                    iconColor: AppColors.iconColor1,
                                                  ),
                                                  IconAndTextWidget(
                                                    text: "1.7km",
                                                    color: AppColors.textColor,
                                                    icon: Icons.location_on,
                                                    iconColor: AppColors.mainColor,
                                                  ),
                                                  IconAndTextWidget(
                                                    text: "32min",
                                                    color: AppColors.textColor,
                                                    icon: Icons.access_time_rounded,
                                                    iconColor: AppColors.iconColor2,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: Dimensions.padding20,
                                              ),
                                              BigText(
                                                  size: 22,
                                                  text: "food_introduce".tr,
                                                  color: AppColors.titleColor),
                                              SizedBox(
                                                height: Dimensions.padding20,
                                              ),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: DescriptionTextWidget(text:product.description),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: Dimensions.detailFoodImgPad,
                                              right: Dimensions.detailFoodImgPad),
                                          height: Dimensions.buttonButtonCon,
                                          padding:
                                          EdgeInsets.only(top: Dimensions.padding30,
                                              bottom: Dimensions.padding30, left: 20, right: 20),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding:  EdgeInsets.all(Dimensions.padding20),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: (){
                                                         Get.find<ProductController>().setQuantity(false, product);
                                                      },
                                                      child: Icon(Icons.remove, color: AppColors.signColor),
                                                    ),
                                                    SizedBox(width: Dimensions.padding10),
                                                    GetBuilder<ProductController>(builder: (_){
                                                      return BigText(text: Get.find<ProductController>().certainItems.toString(), color: AppColors.mainBlackColor);
                                                    },),
                                                    SizedBox(width: Dimensions.padding10),
                                                    GestureDetector(
                                                      onTap: (){
                                                         Get.find<ProductController>().setQuantity(true, product);
                                                      },
                                                      child: Icon(Icons.add, color: AppColors.signColor),
                                                    ),
                                                  ],
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
                                              GestureDetector(
                                                onTap: (){
                                                   Get.find<ProductController>().addItem(product);
                                                },
                                                child: Container(
                                                  child: BigText(
                                                    size: 20,
                                                    text: "\$"+(product.price).toString()+ " "+"add_to_cart".tr,
                                                    color: Colors.white,
                                                  ),
                                                  padding:  EdgeInsets.all(Dimensions.padding20),
                                                  decoration: BoxDecoration(
                                                      color: AppColors.mainColor,
                                                      borderRadius: BorderRadius.circular(Dimensions.padding20),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset: Offset(0, 5),
                                                            blurRadius: 10,
                                                            //spreadRadius: 3,
                                                            color: AppColors.mainColor.withOpacity(0.3))
                                                      ]),
                                                ),
                                              )
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

                            );

                          },
                          child:  Container(
                            margin:  EdgeInsets.only(left: Dimensions.appMargin, right: Dimensions.appMargin, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: Dimensions.listViewImg,
                                  height: Dimensions.listViewImg,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.padding20),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              AppConstants.UPLOADS_URL+searchController.searchProductList![index].img

                                          )
                                      )
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: Dimensions.isWeb?EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL, right: Dimensions.PADDING_SIZE_SMALL):EdgeInsets.all(0),
                                    height: Dimensions.listViewCon,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(Dimensions.padding20),
                                            bottomRight: Radius.circular(Dimensions.padding20)
                                        )
                                    ),
                                    child:Padding(
                                      padding:  EdgeInsets.only(left: Dimensions.padding10, right: Dimensions.padding10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          BigText(text: searchController.searchProductList![index].title,/* element.value,*/
                                              color: Colors.black87),
                                          SizedBox(height: Dimensions.padding10,),
                                          TextWidget(text: "With chinese characteristics", color: AppColors.textColor),
                                          SizedBox(height: Dimensions.padding10,),
                                          Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconAndTextWidget(text: "Normal", color: AppColors.textColor, icon: Icons.circle, iconColor: AppColors.iconColor1,),

                                              IconAndTextWidget(text: "17km",color: AppColors.textColor, icon: Icons.location_on, iconColor: AppColors.mainColor,),

                                              IconAndTextWidget(text: "32min",color:AppColors.textColor, icon: Icons.access_time_rounded, iconColor: AppColors.iconColor2,)
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                )
                              ],
                            ),
                          )
                      );
                    },
                  ))),
                ),
              );
            }),
          ),
        )),

      ]),
    );
  }
}
