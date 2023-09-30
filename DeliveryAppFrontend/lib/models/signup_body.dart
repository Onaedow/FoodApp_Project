class SignUpBody {
  String fName;
  String phone;
  String email;
  String password;
  String country_code;
  String sms_code;

  SignUpBody({required this.fName,

    required this.phone,
    this.email='', required this.password, required this.country_code, required this.sms_code});

 factory SignUpBody.fromJson(Map<String, dynamic> json) {
   return SignUpBody(
       fName : json['f_name'],

       phone : json['phone'],
       email : json['email'],
       password : json['password'],
       sms_code : json['sms_code'],
       country_code : json['country_code']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['f_name'] = this.fName;

    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['sms_code'] = this.sms_code;
    data['country_code'] = this.country_code;
    return data;
  }
}

class VerificationBody {
  String country_code;
  String phone;

  VerificationBody({required this.country_code, required this.phone,});

  factory VerificationBody.fromJson(Map<String, dynamic> json) {
    return VerificationBody(
        country_code : json['country_code'],
        phone : json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_code'] = this.country_code;

    data['phone'] = this.phone;
    return data;
  }
}