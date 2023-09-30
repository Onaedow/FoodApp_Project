import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';

class CustomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      height: 100, width: 100,
      decoration: BoxDecoration(color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(50)),
      alignment: Alignment.center,
      child: CircularProgressIndicator(color:Colors.white),
    ));
  }
}