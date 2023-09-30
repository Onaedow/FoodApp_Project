import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopping_app/base/confirm_dialogue.dart';
import 'package:shopping_app/base/custom_snackbar.dart';
import 'package:shopping_app/data/repos/location_repo.dart';
import 'package:shopping_app/models/address_model.dart';
import 'package:shopping_app/models/response_model.dart';
import 'package:shopping_app/routes/route_helper.dart';
import 'package:google_maps_webservice/src/places.dart';
import '../data/api/api_checker.dart';
import 'cart_controller.dart';

class LocationController extends GetxController implements GetxService {
  late LocationRepo locationRepo;
  LocationController({required this.locationRepo});
  bool _loading = false;

  late Position _position;// = Position(longitude: 45.521563, latitude: -122.677433, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  late Position _pickPosition;// = Position(longitude: 45.521563, latitude: -122.677433, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  Placemark _placeMark = Placemark();
  Placemark _pickPlaceMark = Placemark();
  List<Marker> _markers = <Marker>[];
   List<AddressModel> _addressList=[];
  late List<AddressModel> _allAddressList;
  int _addressTypeIndex = 0;
  List<String> _addressTypeList = ['home', 'office', 'others'];
  bool _isLoading = false;
  bool _inZone = false;
  bool _buttonDisabled = true;
  bool _changeAddress = true;
  late GoogleMapController _mapController;

  bool _updateAddAddressData = true;



  bool get isLoading => _isLoading;
  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  Placemark get placeMark => _placeMark;
  Placemark get pickPlaceMark => _pickPlaceMark;
  List<Marker> get markers => _markers;
  List<AddressModel> get addressList => _addressList;
  List<String> get addressTypeList => _addressTypeList;
  int get addressTypeIndex => _addressTypeIndex;
  bool get inZone => _inZone;
  bool get buttonDisabled => _buttonDisabled;
  GoogleMapController get mapController => _mapController;
/*
new variables
 */
  List<Prediction> _predictionList = [];
  Future<AddressModel> getCurrentLocation(bool fromAddress,
      {required GoogleMapController mapController,
        LatLng? defaultLatLng, bool notify = true}) async {
    _loading = true;
    if(notify) {
      update();
    }
    AddressModel _addressModel;
    Position _myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      _myPosition = newLocalData;
     // print("I am from getcurrentPos1 "+defaultLatLng!.latitude.toString());
    }catch(e) {
      _myPosition = Position(
        latitude: defaultLatLng != null ? defaultLatLng.latitude : double.parse( '0'),
        longitude: defaultLatLng != null ? defaultLatLng.longitude : double.parse( '0'),
        timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
      );
    }
    if(fromAddress) {
      _position = _myPosition;
    }else {
      _pickPosition = _myPosition;
    }
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_myPosition.latitude, _myPosition.longitude), zoom: 17),
      ));
    }
    Placemark _myPlaceMark;
    try {
      if(!GetPlatform.isWeb) {

        List<Placemark> placeMarks = await placemarkFromCoordinates(_myPosition.latitude, _myPosition.longitude);
        _myPlaceMark = placeMarks.first;
      }else {

        String _address = await getAddressFromGeocode(LatLng(_myPosition.latitude, _myPosition.longitude));
        _myPlaceMark = Placemark(name: _address, locality: '', postalCode: '', country: '');
      }
    }catch (e) {
      String _address = await getAddressFromGeocode(LatLng(_myPosition.latitude, _myPosition.longitude));
      _myPlaceMark = Placemark(name: _address, locality: '', postalCode: '', country: '');
    }
    fromAddress ? _placeMark = _myPlaceMark : _pickPlaceMark = _myPlaceMark;
    ResponseModel _responseModel = await getZone(_myPosition.latitude.toString(), _myPosition.longitude.toString(), true);
    _buttonDisabled = !_responseModel.isSuccess;
    _addressModel = AddressModel(
      latitude: _myPosition.latitude.toString(), longitude: _myPosition.longitude.toString(), addressType: 'others',
      //zoneId: _responseModel.isSuccess ? int.parse(_responseModel.message) : 0,
      address: '${_myPlaceMark.name ?? ''}'
          ' ${_myPlaceMark.locality ?? ''} '
          '${_myPlaceMark.postalCode ?? ''} '
          '${_myPlaceMark.country ?? ''}',
    );
    _loading = false;
    update();
    return _addressModel;
  }
  void setPickData() {
    _pickPosition = _position;
    _pickPlaceMark = _placeMark;
  }
  void disableButton() {
    _buttonDisabled = true;
    _inZone = true;
    update();
  }
  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }
  Future<ResponseModel> updateAddress(AddressModel addressModel, int addressId) async {
    _isLoading = true;
    update();
    Response response = await locationRepo.updateAddress(addressModel, addressId);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      getAddressList();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {

    Response response = await locationRepo.getAddressFromGeocode(latLng);
    String _address = 'Unknown Location Found';

    if(response.body['status'] == 'OK') {
      _address = response.body['results'][0]['formatted_address'].toString();
    }else {
      print("error in the api");
    }
    return _address;
  }

  Future<ResponseModel> getZone(String lat, String long, bool markerLoad) async {
    if(markerLoad) {
      _loading = true;
    }else {
      _isLoading = true;
    }
    update();
    ResponseModel _responseModel;
    Response response = await locationRepo.getZone(lat, long);
    if(response.statusCode == 200) {
      _inZone = true;
      _responseModel = ResponseModel(true, response.body['zone_id'].toString());
    }else {
      _inZone = false;
      _responseModel = ResponseModel(false, response.statusText!);
    }
    if(markerLoad) {
      _loading = false;
    }else {
      _isLoading = false;
    }
    update();
    return _responseModel;
  }

  void saveAddressAndNavigate(AddressModel address, bool fromSignUp, String route, bool canRoute) {
    if(Get.find<CartController>().getCarts.length > 0) {
      Get.dialog(ConfirmationDialog(
        icon: "assets/image/warning.png", title: 'are_you_sure_to_reset'.tr, description: 'if_you_change_location'.tr,
        onYesPressed: () {
          Get.back();
          _setZoneData(address, fromSignUp, route, canRoute);
        },
        onNoPressed: () {
          Get.back();
          Get.back();
        },
      ));
    }else {
      _setZoneData(address, fromSignUp, route, canRoute);
    }
  }
  void updatePosition(CameraPosition position, bool fromAddress) async {
    if(_updateAddAddressData) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          _position = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
          );

        } else {
          _pickPosition = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
          );

        }
        ResponseModel _responseModel = await getZone(position.target.latitude.toString(),
            position.target.longitude.toString(), true);
        _buttonDisabled = !_responseModel.isSuccess;
        if (_changeAddress) {

            String _address = await getAddressFromGeocode(
                LatLng(position.target.latitude,
                position.target.longitude)
            );
            print("myg ..${position.target.latitude}");
            print("my address is.. $_address");
            fromAddress ? _placeMark = Placemark(name: _address)
                : _pickPlaceMark = Placemark(name: _address);

        } else {
          _changeAddress = true;
        }
      } catch (e) {
        print(e);
      }
      _loading = false;

      update();
    }else {
      _updateAddAddressData = true;
    }
  }

  void _setZoneData(AddressModel address, bool fromSignUp, String route, bool canRoute) {
    Get.find<LocationController>().getZone(address.latitude, address.longitude, false).then((response) async {
      if (response.isSuccess) {
        Get.find<CartController>().clearCartList();
       // address.zoneId = int.parse(response.message);
        //autoNavigate(address, fromSignUp, route, canRoute);
        Get.toNamed(RouteHelper.getInitialRoute());
      } else {
        Get.back();
        showCustomSnackBar(response.message);
      }
    });
  }

  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      _addressList = [];
      _allAddressList = [];
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    }else{
      _addressList=[];
    }
    update();
  }

  void clearAddressList(){
    _addressList=[];
    update();
  }

  void filterAddresses(String queryText) {
    if(_addressList != null) {
      _addressList = [];
      if (queryText == null || queryText.isEmpty) {
        _addressList.addAll(_allAddressList);
      } else {
        _allAddressList.forEach((address) {
          if (address.address.toLowerCase().contains(queryText.toLowerCase())) {
            _addressList.add(address);
          }
        });
      }
      update();
    }
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _isLoading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    _isLoading = false;
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      getAddressList();
      String message = response.body["message"];
      responseModel = ResponseModel(true, message);
      await Get.find<LocationController>().saveUserAddress(addressModel);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }

    update();
    return responseModel;
  }



  Future<bool> saveUserAddress(AddressModel address) async {
    String userAddress = jsonEncode(address.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }
  late Map<String, dynamic> _getAddress;
  Map get getAddress=>_getAddress;
  AddressModel getUserAddress() {
   late  AddressModel _addressModel;

     _getAddress=jsonDecode(locationRepo.getUserAddress());

    try {
      _addressModel = AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));

    }catch(e) {

    }
    return _addressModel;
  }
  AddressModel? setUserAddress(AddressModel address) {
    AddressModel? _addressModel;
    try {
      _addressModel = AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    }catch(e) {

    }
    return _addressModel;
  }

  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }
/*
  void saveAddressAndNavigate(AddressModel address, bool fromSignUp, String route, bool canRoute) {
    if(Get.find<CartController>().cartList.length > 0) {
      Get.dialog(ConfirmationDialog(
        icon: Images.warning, title: 'are_you_sure_to_reset'.tr, description: 'if_you_change_location'.tr,
        onYesPressed: () {
          Get.back();
         // _setZoneData(address, fromSignUp, route, canRoute);
        },
        onNoPressed: () {
          Get.back();
          Get.back();
        },
      ));
    }else {
      _setZoneData(address, fromSignUp, route, canRoute);
    }
  }
*/





  void setAddAddressData() {
    /*
    with this we are able to update the address data from pick map screen
     */
    _position = _pickPosition;
    _placeMark = _pickPlaceMark;
    _updateAddAddressData = false;
    update();
  }
/*

newly added things
 */
  void setLocation(String placeID, String address, GoogleMapController mapController) async {
    _loading = true;
    update();
    PlacesDetailsResponse detail;
    Response response = await locationRepo.getPlaceDetails(placeID);
    detail = PlacesDetailsResponse.fromJson(response.body);

    _pickPosition = Position(
      longitude: detail.result.geometry!.location.lat, latitude: detail.result.geometry!.location.lng,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
    );

    _pickPlaceMark = Placemark(name: address);
    _changeAddress = false;

    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
        detail.result.geometry!.location.lat, detail.result.geometry!.location.lng,
      ), zoom: 17)));
    }
    _loading = false;
    update();
  }

  Future<List<Prediction>> searchLocation(BuildContext context, String text) async {
    if(text != null && text.isNotEmpty) {
      Response response = await locationRepo.searchLocation(text);
      if (response.statusCode == 200 && response.body['status'] == 'OK') {
        _predictionList = [];
        response.body['predictions'].forEach((prediction)
        => _predictionList.add(Prediction.fromJson(prediction)));
      } else {
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }



}
