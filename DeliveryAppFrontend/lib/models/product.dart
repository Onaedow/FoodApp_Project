class ProductModel {
  late int _totalSize;
  late  int _typeId;
  late int _offset;
  late List<Product> _products;

  ProductModel(
      {required int totalSize,
        required int typeId,
        required int offset,
        required List<Product> products}) {
    this._totalSize = totalSize;
    this._typeId = typeId;
    this._offset = offset;
    this._products = products;
  }

  int get totalSize => _totalSize;
  int get typeId => _typeId;
  int get offset => _offset;
  List<Product> get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _typeId = json['type_id']??0;
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products.add(new Product.fromJson(v));
      });
    }
  }

}

class Product{
  int   id;
  String title;
  String sub_title;
  String img;
  String description;
  double price;
  bool isFavourite;

  Product(
      {required this.id,
        required this.title,
        required this.sub_title,
        required this.img,
        required this.description,
        required this.price,
        this.isFavourite = false});

  factory  Product.fromJson(Map<String, dynamic> json) {
    return Product(  id : json['id'],
      title : json['name'].toString(),
      sub_title : json['sub_title'].toString(),
      img:json['img']??"img/food0.png",
      description:json['description']??'',
      price:double.parse(json['price'].toString()),
      isFavourite:json['isFavourtie']??false,
    );}
  //Convert object to string like
  Map<String, dynamic> toJson() {
    return {

      "id": this.id,
      "name": this.title,
      "quantity": this.sub_title,
      "price": this.price,
      "isExist": this.description,
      'img':this.img,
      //this part we need for accessing the product model
      //so we will this part later
      'isFavourite':this.isFavourite
    };
  }

}
