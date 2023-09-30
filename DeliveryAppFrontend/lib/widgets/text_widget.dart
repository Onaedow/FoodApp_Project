import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color color;
  double size;
  double height;
   TextWidget({Key? key,
  required this.text,
    required this.color,
    this.size=0,
     this.height=1.2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color:color,
        fontSize:size==0?Dimensions.font18:size,
        height: height
      ),
    );
  }
}
