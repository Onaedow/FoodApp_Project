import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/data/api/api_client.dart';
import 'package:shopping_app/models/address_model.dart';
import 'package:shopping_app/uitls/app_constants.dart';

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAllAddress() async {
    return await apiClient.getData(AppConstants.ADDRESS_LIST_URI);
  }
  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.ZONE_URI}?lat=$lat&lng=$lng');
  }

  Future<Response> getAddressFromGeocode(LatLng latLng) async {
    return await apiClient.getData('${AppConstants.GEOCODE_URI}'
        '?lat=${latLng.latitude}&lng=${latLng.longitude}');
  }

  Future<Response> removeAddressByID(int id) async {
    return await apiClient.postData('${AppConstants.REMOVE_ADDRESS_URI}$id', {"_method": "delete"});
  }

  Future<Response> addAddress(AddressModel addressModel) async {
    return await apiClient.postData(AppConstants.ADD_ADDRESS_URI, addressModel.toJson());
  }

  Future<Response> updateAddress(AddressModel addressModel, int addressId) async {
    return await apiClient.postData('${AppConstants.UPDATE_ADDRESS_URI}$addressId', addressModel.toJson());
  }

  Future<bool> saveUserAddress(String address) async {
    print("setting "+address);
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.TOKEN)!);
    return await sharedPreferences.setString(AppConstants.USER_ADDRESS, address);
  }



  String getUserAddress() {
    print("sharedPreferences...... "+sharedPreferences.getString(AppConstants.USER_ADDRESS)!);
    return sharedPreferences.getString(AppConstants.USER_ADDRESS)??"";
  }



  Future<Response> getPlaceDetails(String placeID) async {
    return await apiClient.getData('${AppConstants.PLACE_DETAILS_URI}?placeid=$placeID');
  }
  Future<Response> searchLocation(String text) async {
    return await apiClient.getData('${AppConstants.SEARCH_LOCATION_URI}?search_text=$text');
  }

}
