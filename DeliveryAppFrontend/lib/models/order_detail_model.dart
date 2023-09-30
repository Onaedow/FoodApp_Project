import 'package:shopping_app/models/product.dart';

class OrderDetailsModel {
 late int id;
 late   int foodId;
 late  int orderId;
 late  double price;
 late  Product foodDetails;

 late  double discountOnFood;
 late  String discountType;
 late  int quantity;
 late  double taxAmount;
 late  String variant;
 late   String createdAt;
 late   String updatedAt;


  OrderDetailsModel(
      {required  this.id,
        required this.foodId,
        required  this.orderId,
        required  this.price,
        required  this.foodDetails,
        required  this.discountOnFood,
        required  this.discountType,
        required  this.quantity,
        required  this.taxAmount,
        required  this.variant,
        required  this.createdAt,
        required  this.updatedAt,
});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foodId = json['food_id'];
    orderId = json['order_id'];
    price = json['price'].toDouble();
  /*  foodDetails = (json['food_details'] != null
        ? new Product.fromJson(json['food_details'])
        : null)!;
*/


    quantity = json['quantity'];
    taxAmount = json['tax_amount'].toDouble();

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['food_id'] = this.foodId;
    data['order_id'] = this.orderId;
    data['price'] = this.price;
   /* if (this.foodDetails != null) {
      data['food_details'] = this.foodDetails.toJson();
    }*/



    data['quantity'] = this.quantity;
    data['tax_amount'] = this.taxAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;

    return data;
  }
}


