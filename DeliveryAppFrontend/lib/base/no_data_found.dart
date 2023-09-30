
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
import 'package:shopping_app/uitls/styles.dart';

class NoDataScreen extends StatelessWidget {

  final String text;
  final String imgPath;
  NoDataScreen({required this.text, this.imgPath="assets/image/empty_cart.png"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 200),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        Image.asset(
          imgPath,
          width: MediaQuery.of(context).size.height*0.22,
          height: MediaQuery.of(context).size.height*0.22,
        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.03),
        Text(
          text,
          style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.0175,
              color: Theme.of(context).disabledColor),/*robotoMedium.copyWith(fontSize:
          MediaQuery.of(context).size.height*0.0175,
              color: Theme.of(context).disabledColor)*/
          textAlign: TextAlign.center,
        ),

      ]),
    );
  }
}
