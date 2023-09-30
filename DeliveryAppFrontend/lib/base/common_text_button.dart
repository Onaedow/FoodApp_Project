import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/colors.dart';
import '../uitls/app_dimensions.dart';
import '../widgets/big_text.dart';
import 'package:get/get.dart';

class CommonTextButton extends StatelessWidget {
  final String text;
  const CommonTextButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Center(
        child: BigText(
          size: 20,
          text: text.tr,
          color: Colors.white,
        ),
      ),
      padding:  EdgeInsets.all(Dimensions.padding20),
      decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(Dimensions.padding20),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                blurRadius: 10,
                //spreadRadius: 3,
                color: AppColors.mainColor.withOpacity(0.3))
          ]),
    );
  }
}
