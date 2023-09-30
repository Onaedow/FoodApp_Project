class ConfigModel {
  String? businessName;

  BaseUrls? baseUrls;

  DefaultLocation? defaultLocation;
  String? timeformat;

  bool? cashOnDelivery;
  bool? digitalPayment;
  bool? maintenanceMode;
  bool? showDmEarning;
  bool? canceledByDeliveryman;
  bool? orderDeliveryVerification;
  String? orderConfirmationModel;
  String? currencySymbol;
  int? digitAfterDecimalPoint;
  ConfigModel({this.businessName,
    this.baseUrls,
    this.defaultLocation,
    this. timeformat,
    this.cashOnDelivery,
    this.digitalPayment,
    this.maintenanceMode,
    this.showDmEarning,
    this.canceledByDeliveryman,
    this.orderDeliveryVerification,
    this.orderConfirmationModel,
    this.currencySymbol,
    this.digitAfterDecimalPoint,
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
    maintenanceMode = json['maintenance_mode'];
    showDmEarning = json['show_dm_earning'];
    canceledByDeliveryman = json['canceled_by_deliveryman'];
    orderDeliveryVerification = json['order_delivery_verification'];
    orderConfirmationModel = json['order_confirmation_model'];
    currencySymbol=json['currency_symbol'];
    digitAfterDecimalPoint=json['digit_after_decimal_point'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_name'] = this.businessName;

    data['timeformat'] = this.timeformat;
    data['maintenance_mode']=this.maintenanceMode;
    data['show_dm_earning']=this.showDmEarning;
    data['base_urls'] = this.baseUrls?.toJson();
    data['cash_on_delivery'] = this.cashOnDelivery;
    data['digital_payment'] = this.digitalPayment;
    data['canceled_by_delivery_man']=   this.canceledByDeliveryman;
    data['order_delivery_verification']= orderDeliveryVerification ;
    data['order_confirmation_model']=orderConfirmationModel;
    data['currency_symbol']=currencySymbol;
    data['digit_after_decimal_point']=digitAfterDecimalPoint;
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
  String? deliveryManImageUrl;
  String? productImageUrl;

  BaseUrls(
      {
         this.customerImageUrl,
         this.notificationImageUrl,
         this.businessLogoUrl,
         this.deliveryManImageUrl,
         this.productImageUrl});

  BaseUrls.fromJson(Map<String, dynamic> json) {
    customerImageUrl = json['customer_image_url'];
    notificationImageUrl = json['notification_image_url'];
    businessLogoUrl = json['business_logo_url'];
    deliveryManImageUrl = json['delivery_man_image_url'];
    productImageUrl = json['product_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_image_url'] = this.customerImageUrl;
    data['notification_image_url'] = this.notificationImageUrl;
    data['business_logo_url'] = this.businessLogoUrl;
    data['delivery_man_image_url'] = this.deliveryManImageUrl;
    data['product_image_url'] = this.productImageUrl;
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
