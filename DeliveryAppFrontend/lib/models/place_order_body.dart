import 'package:flutter/material.dart';

import 'cart_item.dart';

class PlaceOrderBody {
  late List<CartItem> _cart;

  late double _orderAmount;
  late String _paymentMethod;
  late String _orderNote;
  late String _couponCode;
  late String _scheduleAt;
  late double _discountAmount;
  late double _taxAmount;
  late String _address;
  late String _latitude;
  late String _longitude;
  late String _contactPersonName;
  late String _contactPersonNumber;
  late String _addressType;

  PlaceOrderBody(
      {required List<CartItem> cart,

        required double orderAmount,
        required String paymentMethod,
        required int restaurantId,
        required double distance,
        required String scheduleAt,
        required double discountAmount,
        required double taxAmount,
        required String orderNote,
        required String address,
        required String latitude,
        required String longitude,
        required String contactPersonName,
        required String contactPersonNumber,
        required String addressType,
      }) {
    this._cart = cart;

    this._orderAmount = orderAmount;
    this._paymentMethod = paymentMethod;
    this._orderNote = orderNote;
    this._couponCode = couponCode;

    this._scheduleAt = scheduleAt;
    this._discountAmount = discountAmount;
    this._taxAmount = taxAmount;
    this._address = address;
    this._latitude = latitude;
    this._longitude = longitude;
    this._contactPersonName = contactPersonName;
    this._contactPersonNumber = contactPersonNumber;
    this._addressType = addressType;
  }

  List<CartItem> get cart => _cart;

  double get orderAmount => _orderAmount;
  String get paymentMethod => _paymentMethod;
  String get orderNote => _orderNote;
  String get couponCode => _couponCode;

  String get scheduleAt => _scheduleAt;
  double get discountAmount => _discountAmount;
  double get taxAmount => _taxAmount;
  String get address => _address;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get contactPersonName => _contactPersonName;
  String get contactPersonNumber => _contactPersonNumber;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart.add(new CartItem.fromJson(v));
      });
    }

    _orderAmount = json['order_amount'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
;
    _scheduleAt = json['scheduled_at'];
    _discountAmount = json['discount_amount'].toDouble();
    _taxAmount = json['tax_amount'].toDouble();
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _contactPersonName = json['contact_person_name'];
    _contactPersonNumber = json['contact_person_number'];
    _addressType = json['address_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._cart != null) {
      data['cart'] = this._cart.map((v) => v.toJson()).toList();
    }

    data['order_amount'] = this._orderAmount;
    data['payment_method'] = this._paymentMethod;
    data['order_note'] = this._orderNote;
    data['coupon_code'] = this._couponCode;

    data['scheduled_at'] = this._scheduleAt;
    data['discount_amount'] = this._discountAmount;
    data['tax_amount'] = this._taxAmount;
    data['address'] = this._address;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['contact_person_name'] = this._contactPersonName;
    data['contact_person_number'] = this._contactPersonNumber;
    data['address_type'] = this._addressType;
    return data;
  }
}


