class UserInfoModel {
  int? id;
  String fName;
  String email;
   String? image;
  String phone;
  String? password;
   int orderCount;
  int? memberSinceDays;

  UserInfoModel(
      { this.id,
        required this.fName,
        required this.email,
        this.image="",
        required this.phone,
         this.password,
        this.orderCount=0,
         this.memberSinceDays});

 factory UserInfoModel.fromJson(Map<String, dynamic> json) {
      return UserInfoModel(
          id : json['id'],
          fName : json['f_name'],
          email : json['email'],
          image : json['image']??null,
          phone : json['phone'],
          password : json['password']??"",
          orderCount : json['order_count'],
          memberSinceDays : json['member_since_days'],
      );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['id'] = this.id;
    data['f_name'] = this.fName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['order_count'] = this.orderCount;
    data['member_since_days'] = this.memberSinceDays;
    return data;
  }
}
