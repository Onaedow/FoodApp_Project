import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/controllers/auth_controller.dart';
import 'package:shopping_app/controllers/location_controller.dart';
import 'package:shopping_app/controllers/user_controller.dart';
import 'package:shopping_app/models/address_model.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/screens/address/pick_map_screen.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
import 'package:shopping_app/widgets/big_text.dart';

import '../../base/custom_snackbar.dart';
import '../location/permission_dialogue.dart';

class AddAddressScreen extends StatefulWidget {

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
   TextEditingController _addressController = TextEditingController();
   var _contactPersonNameController = TextEditingController();
   var _contactPersonNumberController = TextEditingController();

  late bool _isLoggedIn;
    CameraPosition _cameraPosition=CameraPosition(target:
    LatLng(45.521563, -122.677433),zoom: 17);
   late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
   if(Get.find<LocationController>().addressList.isEmpty){
     _initialPosition =  LatLng(45.521563, -122.677433);
   }else{
     if(Get.find<LocationController>().getUserAddress().address.isNotEmpty){
       print("My address is "+Get.find<LocationController>().getUserAddress().address);
       print("Lat is "+Get.find<LocationController>().getAddress["latitude"].toString());

       _cameraPosition=
           CameraPosition(target:LatLng(
               double.parse(Get.find<LocationController>().getAddress["latitude"]),
           double.parse(Get.find<LocationController>().getAddress["longitude"])),zoom: 17);
       _initialPosition =
           LatLng(double.parse(Get.find<LocationController>().getAddress["latitude"]),
           double.parse(Get.find<LocationController>().getAddress["longitude"]));
     }/*else{
       print("Are we here");
       _initialPosition =  LatLng(45.521563, -122.677433);
     }*/
   }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text("Add Address"),
      ),
      body: _isLoggedIn ? GetBuilder<UserController>(builder: (userController) {

          _contactPersonNameController.text = '${userController.userInfoModel?.fName}';
          _contactPersonNumberController.text = '${userController.userInfoModel?.phone}';
          if(Get.find<LocationController>().addressList.isNotEmpty){
            _addressController.text=Get.find<LocationController>().getUserAddress().address;
            print("address from database"+_addressController.text);
          }


        return GetBuilder<LocationController>(builder: (locationController) {
          //comes at the end of this tutorial page.
          _addressController.text = '${locationController.placeMark.name ?? ''} '
              '${locationController.placeMark.locality ?? ''} '
              '${locationController.placeMark.postalCode ?? ''} '
              '${locationController.placeMark.country ?? ''}';
          print("I am getting from placemark .."+'${locationController.placeMark.name}');
          return Column(children: [
            Expanded(child: Scrollbar(child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Center(
                  child: SizedBox(
                  width: Dimensions.WEB_MAX_WIDTH,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    child: Stack(clipBehavior: Clip.none, children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 17),
                        onTap: (latLng) {

                          Get.toNamed(RouteHelper.getPickMapRoute('add-address', false),
                              arguments: PickMapScreen(
                                fromAddAddress: true,
                                fromSignUp: false,
                                googleMapController: locationController.mapController,
                                route: "", canRoute: false,
                          ));
                        },
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        indoorViewEnabled: true,
                        mapToolbarEnabled: false,
                        myLocationEnabled: true,
                        onCameraIdle: () {
                          print("tapping for udpate");
                          locationController.updatePosition(_cameraPosition, true);
                        },
                        onCameraMove: ((position){
                          print("...camera move...");
                          _cameraPosition = position;
                        }),
                        onMapCreated: (GoogleMapController controller) {
                          print("I am from address page");
                          locationController.setMapController(controller);
                          //locationController.getCurrentLocation(true, mapController: controller);
                        },
                      ),
                      locationController.loading ? Center(child: CircularProgressIndicator()) : SizedBox(),
                      Center(child: !locationController.loading ? Icon(Icons.web)
                          : CircularProgressIndicator()),
                      Positioned(
                        top: 10, right: 0,
                        child: InkWell(
          onTap: () => _checkPermission(() {
          locationController.getCurrentLocation(true, mapController: locationController.mapController);
          }),
                          child: Container(
                            width: 30, height: 30,
                            margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.white),
                            child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                SizedBox(height: 50, child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: locationController.addressTypeList.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      locationController.setAddressTypeIndex(index);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,
                          vertical: Dimensions.PADDING_SIZE_SMALL),
                      margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).cardColor,
                        boxShadow: [BoxShadow(color: Colors.grey[200]!,
                            spreadRadius: 1, blurRadius: 5)],
                      ),
                      child: Row(children: [
                        Icon(
                          index == 0 ? Icons.home_filled : index == 1 ? Icons.work : Icons.location_on,
                          color: locationController.addressTypeIndex == index
                              ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      ]),
                    ),
                  ),
                )),
                SizedBox(height: 20),
                BigText(text:"Delivery Adddress", color:AppColors.mainBlackColor),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Container(
                  decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: Offset(1, 1),
                            color:Colors.grey.withOpacity(0.2)
                        )
                      ]
                  ),
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        hintText: "Delivery adddress",
                        prefixIcon: Icon(Icons.email, color:AppColors.yellowColor),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color:Colors.white,
                                width: 1.0
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color:Colors.white,
                                width: 1.0
                            )
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)
                        )
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                BigText(text:"Contact person name", color:AppColors.mainBlackColor),

                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Container(
                  decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: Offset(1, 1),
                            color:Colors.grey.withOpacity(0.2)
                        )
                      ]
                  ),
                  child: TextField(
                    controller: _contactPersonNameController,
                    decoration: InputDecoration(
                        hintText: "Contact person name",
                        prefixIcon: Icon(Icons.email, color:AppColors.yellowColor),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color:Colors.white,
                                width: 1.0
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color:Colors.white,
                                width: 1.0
                            )
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)
                        )
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                BigText(text:"Contact person number",color:AppColors.mainBlackColor),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Container(
                  decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: Offset(1, 1),
                            color:Colors.grey.withOpacity(0.2)
                        )
                      ]
                  ),
                  child: TextField(
                    controller: _contactPersonNumberController,
                    decoration: InputDecoration(
                        hintText: "Contact person number",
                        prefixIcon: Icon(Icons.email, color:AppColors.yellowColor),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color:Colors.white,
                                width: 1.0
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color:Colors.white,
                                width: 1.0
                            )
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)
                        )
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              ]))),
            ))),

          ]);
        });
      }) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("img/signintocontinue.png"),
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getSignInRoute());
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  color: AppColors.yellowColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BigText(
                      text: "Sign in here! ",
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.login,
                      color: Colors.white,
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: GetBuilder<LocationController>(builder:(locationController){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              height: Dimensions.height20*8,
              padding: EdgeInsets.only(top:Dimensions.height30, bottom: Dimensions.height30,
                  left: Dimensions.width20, right: Dimensions.width20),
              decoration: BoxDecoration(
                  color: AppColors.buttonBackgroundColor,
                  borderRadius: BorderRadius.only(

                      topLeft: Radius.circular(Dimensions.radius20*2),
                      topRight: Radius.circular(Dimensions.radius20*2)
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  GestureDetector(
                      onTap: (){
                        print("here is "+_addressController.text);
                        AddressModel _addressModel = AddressModel(
                          addressType: locationController.addressTypeList[locationController.addressTypeIndex],
                          contactPersonName: _contactPersonNameController.text,
                          contactPersonNumber: _contactPersonNumberController.text,
                          address: _addressController.text,
                          latitude: locationController.position.latitude.toString(),
                          longitude: locationController.position.longitude.toString(),
                        );
                        locationController.addAddress(_addressModel).then((response){
                          if(response.isSuccess){
                            Get.toNamed(RouteHelper.getInitialRoute());

                            showCustomSnackBar("Added Successfully", title: "Address", isError: false);
                          }else{
                            showCustomSnackBar("Couldn't save address", title: "Address",);

                          }
                        });
                      },
                      child:Container(
                        padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20,left: Dimensions.width20, right: Dimensions.width20),

                        child: BigText(text: "Save address", color: Colors.white,size:26),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                            color: AppColors.mainColor
                        ),
                      )
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
   void _checkPermission(Function onTap) async {
     LocationPermission permission = await Geolocator.checkPermission();
     if(permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();
     }
     if(permission == LocationPermission.denied) {
       showCustomSnackBar('you_have_to_allow'.tr);
     }else if(permission == LocationPermission.deniedForever) {
       Get.dialog(PermissionDialog());
     }else {
       onTap();
     }
   }
}