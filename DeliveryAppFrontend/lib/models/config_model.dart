class ConfigModel {
  String? businessName;

  BaseUrls? baseUrls;

  DefaultLocation? defaultLocation;
  String? timeformat;

  bool? cashOnDelivery;
  bool? digitalPayment;

  ConfigModel({required this.businessName,

    required this.baseUrls,

    required this.defaultLocation,
    required this. timeformat,
    required this.cashOnDelivery,
    required this.digitalPayment
  });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];

    baseUrls =
    json['base_urls'] != null ? BaseUrls.fromJson(json['base_urls']) : null;

    defaultLocation =
    json['default_location'] != null ? DefaultLocation.fromJson(
        json['default_location']) : null;
    timeformat = json['timeformat'];
    cashOnDelivery = json["cash_on_delivery"];
    digitalPayment = json["digital_payment"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_name'] = this.businessName;

    data['timeformat'] = this.timeformat;
      data['base_urls'] = this.baseUrls?.toJson();
      data['cash_on_delivery'] = this.cashOnDelivery;
      data['digital_payment'] = this.digitalPayment;
      if (this.defaultLocation != null) {
        data['default_location'] = this.defaultLocation?.toJson();
      }


      return data;

  }
}

class BaseUrls {
  String? customerImageUrl;
  String? notificationImageUrl;
  String? businessLogoUrl;

  BaseUrls(
      {
        required this.customerImageUrl,
        required this.notificationImageUrl,
        required this.businessLogoUrl});

  BaseUrls.fromJson(Map<String, dynamic> json) {
    customerImageUrl = json['customer_image_url'];
    notificationImageUrl = json['notification_image_url'];
    businessLogoUrl = json['business_logo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_image_url'] = this.customerImageUrl;
    data['notification_image_url'] = this.notificationImageUrl;
    data['business_logo_url'] = this.businessLogoUrl;
    return data;
  }
}

class DefaultLocation {
  String? lat;
  String? lng;

  DefaultLocation({this.lat, this.lng});

  DefaultLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
