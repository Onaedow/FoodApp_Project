import 'package:the_best_food/util/colors.dart';
import 'package:the_best_food/util/dimensions.dart';
import 'package:the_best_food/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  void Function()? onTap;
  double size;

  TitleWidget({required this.title, this.onTap, this.size=0});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: TextStyle(
        fontSize: size,
        color: Colors.white
      )),
      onTap != null ? InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.view_array_outlined, size: 20,color: Colors.white,),
            SizedBox(width:Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              'view_all'.tr,
              style: robotoMedium.copyWith(fontSize: size==0?Dimensions.FONT_SIZE_SMALL:size, color: Colors.white),
            )
          ],
        ),
      ) : SizedBox(),
    ]);
  }
}
