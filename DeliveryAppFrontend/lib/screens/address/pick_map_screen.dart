import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopping_app/base/custom_button.dart';
import 'package:shopping_app/base/custom_snackbar.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/controllers/location_controller.dart';
import 'package:shopping_app/models/address_model.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
import 'package:shopping_app/uitls/styles.dart';

import '../location/location_search_dialogue.dart';

class PickMapScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddAddress;
  final bool canRoute;
  final String route;
  final GoogleMapController? googleMapController;
  PickMapScreen({required this.fromSignUp, required this.fromAddAddress, required this.canRoute,
    required this.route, this.googleMapController});

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;//=CameraPosition(target: LatLng(double.parse(Get.find<LocationController>().getAddress["latitude"]), double.parse(Get.find<LocationController>().getAddress["longitude"]))  /*LatLng(45.521563, -122.677433)*/,zoom: 17);
  late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();

    if(widget.fromAddAddress) {
      Get.find<LocationController>().setPickData();
    }
    if(Get.find<LocationController>().addressList.isEmpty){
      _initialPosition =  LatLng(45.521563, -122.677433);
    }else{
      if(Get.find<LocationController>().getUserAddress().address.isNotEmpty){

        _cameraPosition=CameraPosition(target:  LatLng(double.parse(Get.find<LocationController>().getAddress["latitude"]),
            double.parse(Get.find<LocationController>().getAddress["longitude"])),zoom: 17);
        _initialPosition =  LatLng(double.parse(Get.find<LocationController>().getAddress["latitude"]),
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
      //appBar: AppBar(title: Text("Pick Address"),backgroundColor: AppColors.mainColor,),
      body: SafeArea(child: Center(child: SizedBox(
        width: Dimensions.WEB_MAX_WIDTH,
        child: GetBuilder<LocationController>(builder: (locationController) {
         /* print('--------------${'${locationController.pickPlaceMark.name ?? ''} '
              '${locationController.pickPlaceMark.locality ?? ''} '
              '${locationController.pickPlaceMark.postalCode ?? ''} ${locationController.pickPlaceMark.country ?? ''}'}');*/

          return Stack(children: [

            GoogleMap(
              initialCameraPosition: CameraPosition(

                target:  _initialPosition,
                zoom: 17,
              ),
              onMapCreated: (GoogleMapController mapController) {
                _mapController = mapController;
                if(!widget.fromAddAddress) {
                  print("pick from web");
                  Get.find<LocationController>().getCurrentLocation(false, mapController: mapController);
                }
              },
              zoomControlsEnabled: false,
              onCameraMove: (CameraPosition cameraPosition) {
                _cameraPosition = cameraPosition;
              },
              onCameraMoveStarted: () {
                locationController.disableButton();
              },
              onCameraIdle: () {
                Get.find<LocationController>().updatePosition(_cameraPosition,
                    false);
              },
            ),

            Center(child: !locationController.loading ?
            Image.asset("assets/image/pick_marker.png", height: 50, width: 50)
                : CircularProgressIndicator()),

            Positioned(
              top: Dimensions.PADDING_SIZE_LARGE,
              left: Dimensions.PADDING_SIZE_SMALL, right: Dimensions.PADDING_SIZE_SMALL,
              child: InkWell(
                onTap: () => Get.dialog(LocationSearchDialog(mapController: _mapController)),
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                  child: Row(children: [
                    Icon(Icons.location_on, size: 25, color: Theme.of(context).primaryColor),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    //here we show the address on the top
                    Expanded(
                      child: Text(
                        '${locationController.pickPlaceMark.name ?? ''} ${locationController.pickPlaceMark.locality ?? ''} '
                            '${locationController.pickPlaceMark.postalCode ?? ''} ${locationController.pickPlaceMark.country ?? ''}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Icon(Icons.search, size: 20, color: Theme.of(context).textTheme.bodyText1!.color),
                  ]),
                ),
              ),
            ),

            Positioned(
              bottom: 80, right: Dimensions.PADDING_SIZE_SMALL,
              child: FloatingActionButton(
                child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
                mini: true, backgroundColor: Theme.of(context).cardColor,
                onPressed: () => _checkPermission(() {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController);
                }),
              ),
            ),

            Positioned(
              bottom: Dimensions.PADDING_SIZE_LARGE,
              left: Dimensions.PADDING_SIZE_SMALL,
              right: Dimensions.PADDING_SIZE_SMALL,
              child: !locationController.isLoading ? CustomButton(
                buttonText: locationController.inZone ? widget.fromAddAddress ? 'pick_address'.tr : 'pick_location'.tr
                    : 'service_not_available_in_this_area'.tr,
                onPressed: (locationController.buttonDisabled || locationController.loading) ? null : () {
                  if(locationController.pickPosition.latitude != 0 &&
                      locationController.pickPlaceMark.name != null) {
                    if(widget.fromAddAddress) {
                      if(widget.googleMapController != null) {
                        print('---address----');
                        widget.googleMapController!.moveCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                          locationController.pickPosition.latitude,
                              locationController.pickPosition.longitude,
                        ), zoom: 17)));
                        locationController.setAddAddressData();
                      }
                     Get.toNamed(RouteHelper.getAddAddressRoute());
                    }else {
                      print("....saving address....");
                      AddressModel _address = AddressModel(
                        latitude: locationController.pickPosition.latitude.toString(),
                        longitude: locationController.pickPosition.longitude.toString(),
                        addressType: 'others', address: '${locationController.pickPlaceMark.name ?? ''} '
                          '${locationController.pickPlaceMark.locality ?? ''} '
                          '${locationController.pickPlaceMark.postalCode ?? ''} ${locationController.pickPlaceMark.country ?? ''}',
                      );
                      locationController.saveAddressAndNavigate(_address, widget.fromSignUp, widget.route, widget.canRoute);
                    }
                  }else {
                    showCustomSnackBar('pick_an_address'.tr);
                  }
                },
              ) : Center(child: CircularProgressIndicator()),
            ),

          ]);
        }),
      ))),
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
      print("permission denied");
    }else {
      onTap();
    }
  }
}
