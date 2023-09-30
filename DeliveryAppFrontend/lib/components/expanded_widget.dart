import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/components/colors.dart';
import 'package:shopping_app/uitls/app_dimensions.dart';
import 'package:shopping_app/widgets/text_widget.dart';
class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() => new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;
  double textHeight=Dimensions.screenSizeHeight/5.63;
  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt()+1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(bottom: Dimensions.margin80),
      child: secondHalf.isEmpty
          ? new TextWidget(size:16,text:firstHalf, color: AppColors.paraColor,height: 1.8,)
          : new Column(
        children: <Widget>[
          new TextWidget(size:16,height:1.8,text:flag ? (firstHalf + "...") : (firstHalf + secondHalf), color: AppColors.paraColor,),
          SizedBox(height: 5,),
          new InkWell(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new TextWidget(
                  text: flag ? "show_more".tr : "show_less".tr,
                  color:AppColors.mainColor,
                  size: 14,
                ),
                Icon(flag?Icons.keyboard_arrow_down_outlined:Icons.keyboard_arrow_up_outlined, color: AppColors.mainColor,)
              ],
            ),
            onTap: () {
              setState(() {
                flag = !flag;
              });
            },
          ),
          SizedBox(height: 50,)

        ],
      ),
    );
  }
}
