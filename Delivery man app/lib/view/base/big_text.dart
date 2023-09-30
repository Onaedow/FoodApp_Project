
import 'package:flutter/cupertino.dart';

import '../../util/dimensions.dart';

class BigText extends StatelessWidget {
  final String text;
  final Color color;
  double size;
  TextOverflow overFlow;
  BigText({
    required this.text,
    required this.color,
    this.size=0,
    this.overFlow=TextOverflow.ellipsis
  });

  @override
  Widget build(BuildContext context) {
    return Text(

        text,
        maxLines: 1,
        overflow: overFlow,
        softWrap: false,
        style: TextStyle(
          fontFamily: 'Roboto',
          color:color,
          fontSize:size==0?Dimensions.font20:size,
          fontWeight: FontWeight.w400,
        )
      // robotoRegular,
    );
  }
}
