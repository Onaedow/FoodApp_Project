
import 'package:get/get.dart';

class Dimensions {
  //screen size and width based on context
  static double screenSizeWidth=Get.context!.width;
  static double screenSizeHeight = Get.context!.height;
  static const double FONT_SIZE_EXTRA_SMALL = 10.0;
  static const double FONT_SIZE_SMALL = 12.0;
  static const double FONT_SIZE_DEFAULT = 14.0;
  static const double FONT_SIZE_LARGE = 16.0;
  static const double FONT_SIZE_EXTRA_LARGE = 18.0;
  static const double FONT_SIZE_OVER_LARGE = 24.0;

  static const double PADDING_SIZE_EXTRA_SMALL = 5.0;
  static const double PADDING_SIZE_SMALL = 10.0;
  static const double PADDING_SIZE_DEFAULT = 15.0;
  static const double PADDING_SIZE_LARGE = 20.0;
  static const double PADDING_SIZE_EXTRA_LARGE = 25.0;

  static const double RADIUS_SMALL = 5.0;
  static const double RADIUS_DEFAULT = 10.0;
  static const double RADIUS_LARGE = 15.0;
  static const double RADIUS_EXTRA_LARGE = 20.0;

  //dynamic font
  static double font18=screenSizeHeight/70.33;
  static double font20=screenSizeHeight/42.2;
  static double font22=screenSizeHeight/38.36;
  static double font26=screenSizeHeight/32.46;
  static double font30=screenSizeHeight/28.13;
}
