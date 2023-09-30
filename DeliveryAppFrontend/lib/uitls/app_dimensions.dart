
import 'package:get/get.dart';

class Dimensions {
  static double fontSizeExtraSmall = Get.context!.width >= 1170 ? 16 : 10;
  static double fontSizeSmall = Get.context!.width >= 1170 ? 18 : 12;
  static double fontSizeDefault = Get.context!.width >= 1170 ? 26 : 20;
  static double fontSizeLarge = Get.context!.width >= 1170 ? 22 : 16;
  static double fontSizeExtraLarge = Get.context!.width >= 1170 ? 24 : 18;
  static double fontSizeOverLarge = Get.context!.width >= 1170 ? 30 : 24;

  //screen size and width based on context
  static double screenSizeWidth=Get.context!.width;
  static double screenSizeHeight = Get.context!.height;

  static const double PADDING_SIZE_EXTRA_SMALL = 5.0;
  static const double PADDING_SIZE_SMALL = 10.0;
  static const double PADDING_SIZE_DEFAULT = 15.0;

  static const double PADDING_SIZE_EXTRA_LARGE = 25.0;


  static const double VIEW_PORT_MOBILE=0.85;
  static const double VIEW_PORT_DESKTOP=0.74;
  static const double LIST_VIEW_CON_SIZE_MOBILE=120;
  static const double LIST_VIEW_CON_SIZE_DESKTOP=200;
  static const double LIST_VIEW_CON_SIZE=100;
  static const double LIST_VIEW_CON_DESKTOP=160;

  //common app marig or padding
  static double appMargin=screenSizeWidth>WEB_MAX_WIDTH?MARGIN_SIZE_EXTRA_LARGE:screenSizeWidth/18.75;
  static double sizedBoxHeight = screenSizeWidth>WEB_MAX_WIDTH?20:screenSizeWidth/12.5;
  static double viewPort = screenSizeWidth>WEB_MAX_WIDTH?VIEW_PORT_DESKTOP:VIEW_PORT_MOBILE;
  static double listViewImg=
  screenSizeWidth>WEB_MAX_WIDTH?LIST_VIEW_CON_SIZE_DESKTOP:screenSizeWidth/3.12;

  static double listViewCon=
  screenSizeWidth>WEB_MAX_WIDTH?LIST_VIEW_CON_SIZE_DESKTOP-40:screenSizeWidth/3.75;

  //page view
  static const double PAGE_VIEW_CON=500;
  static const double PAGE_VIEW_CON_DESK=600;
  static const double PAGE_VIEW_CON_TEXT=150;
  static  double pageViewCon=screenSizeWidth>WEB_MAX_WIDTH?PAGE_VIEW_CON_DESK:screenSizeHeight/2.64;

  static double pageViewInnerCon=screenSizeWidth>WEB_MAX_WIDTH?PAGE_VIEW_CON:screenSizeHeight/3.83;
  static double pageViewInnerConText=screenSizeWidth>WEB_MAX_WIDTH?PAGE_VIEW_CON_TEXT:screenSizeHeight/7.03;

  //detail food
  static const double DETAIL_FOOD_IMG=400;

  static double detailFoodImg=screenSizeWidth>WEB_MAX_WIDTH?double.maxFinite-400:screenSizeHeight/2.11;
  static double detailFoodImgWidth=screenSizeWidth>WEB_MAX_WIDTH?double.maxFinite-400:double.maxFinite;
  static double detailFoodImgPad=screenSizeWidth>WEB_MAX_WIDTH?MARGIN_SIZE_EXTRA_LARGE:0;

  //page view
  static const double MORE_VIEW_CON=500;
  static const double MORE_VIEW_CON_DESK=400;
  static const double MORE_VIEW_CON_TEXT=150;
  static  double moreViewCon=screenSizeWidth>WEB_MAX_WIDTH?PAGE_VIEW_CON_DESK:screenSizeHeight/2.64;

  static double moreViewInnerCon=screenSizeWidth>WEB_MAX_WIDTH?PAGE_VIEW_CON:screenSizeHeight/3.83;
  static double moreViewInnerConText=screenSizeWidth>WEB_MAX_WIDTH?PAGE_VIEW_CON_TEXT:screenSizeHeight/7.03;

  //top bar home page
  static const double TOP_BAR_WEB=15;
  static const double TOP_BAR_MOB=60;
  static double topBar=screenSizeWidth>WEB_MAX_WIDTH?TOP_BAR_WEB:TOP_BAR_MOB;
  //bottom buttons
  static const double BUTTOM_BUTTON_CON=120;
  static double buttonButtonCon=screenSizeWidth>WEB_MAX_WIDTH?BUTTOM_BUTTON_CON:screenSizeHeight/6.63;



  static const double RADIUS_SMALL = 5.0;
  static const double RADIUS_DEFAULT = 10.0;
  static const double RADIUS_LARGE = 15.0;
  static const double WEB_MAX_WIDTH = 1170;
  static bool isWeb=screenSizeWidth>WEB_MAX_WIDTH?true:false;
  static  double SPLASH_IMG_WIDTH=screenSizeWidth>WEB_MAX_WIDTH?500:250;
  static const double PADDING_SIZE_LARGE = 20.0;
  //dynamic padding
  static const double PADDING_SIZE_5=5.0;
  static const double PADDING_SIZE_20 = 20.0;
  static const double PADDING_SIZE_30 = 30.0;
  static const double PADDING_SIZE_40 = 40.0;
  static double padding5=screenSizeWidth>WEB_MAX_WIDTH?PADDING_SIZE_5:screenSizeHeight/168.8;
  static double padding20=screenSizeWidth>WEB_MAX_WIDTH?PADDING_SIZE_20:screenSizeHeight/42.2;
  static double padding30=screenSizeWidth>WEB_MAX_WIDTH?PADDING_SIZE_30:screenSizeHeight/28.13;
  static double padding40=screenSizeWidth>WEB_MAX_WIDTH?PADDING_SIZE_40:screenSizeHeight/21.10;
  static double padding10=screenSizeWidth>WEB_MAX_WIDTH?PADDING_SIZE_SMALL:screenSizeHeight/84.4;


  //dynamic margin
  static const double MARGIN_SIZE_EXTRA_LARGE = 200.0;
  static const double MARGIN_SIZE_80 = 80.0;
  static const double MARGIN_SIZE_40 = 40.0;
  static const double MARGIN_SIZE_35=35.0;
  static const double MARGIN_SIZE_30=30.0;
  static double margin40=screenSizeWidth>WEB_MAX_WIDTH?MARGIN_SIZE_40:screenSizeHeight/21.1;
  static double margin80=screenSizeWidth>WEB_MAX_WIDTH?MARGIN_SIZE_80:screenSizeHeight/10.55;
  static double margin35=screenSizeWidth>WEB_MAX_WIDTH?MARGIN_SIZE_35:screenSizeHeight/24.11;


  //dynamic font
  static double font18=screenSizeWidth>WEB_MAX_WIDTH?18:screenSizeHeight/70.33;
  static double font20=screenSizeWidth>WEB_MAX_WIDTH?screenSizeHeight/32.46:screenSizeHeight/42.2;
  static double font22=screenSizeWidth>WEB_MAX_WIDTH?22:screenSizeHeight/38.36;
  static double font26=screenSizeWidth>WEB_MAX_WIDTH?26:screenSizeHeight/32.46;
  static double font30=screenSizeWidth>WEB_MAX_WIDTH?30:screenSizeHeight/28.13;

  //dynamic sliver height
  static const double SLIVER_HEIGHT=350;
  static const double SLIVER_IMG=300;
  static const double SLIVER_DEC=50;
  static double sliverHeight=screenSizeWidth>WEB_MAX_WIDTH?SLIVER_HEIGHT:screenSizeHeight/2.41;
  static double sliverImg=screenSizeWidth>WEB_MAX_WIDTH?SLIVER_IMG:screenSizeHeight/2.81;
  static double sliverDec=screenSizeWidth>WEB_MAX_WIDTH?SLIVER_DEC:screenSizeHeight/16.88;

  static const double ICON_BACK_SIZE=50;
  static double iconBackSize=screenSizeWidth>WEB_MAX_WIDTH?ICON_BACK_SIZE:screenSizeHeight/16.88;

  static const double BORDER_RADIUS_15=15;
  static double borderRadius15=screenSizeWidth>WEB_MAX_WIDTH?BORDER_RADIUS_15:screenSizeHeight/56.27;

  //dynamic buttom buttons
  static const double BUTTOM_BUTTON=120;
  static double buttomButton=screenSizeWidth>WEB_MAX_WIDTH?150:screenSizeHeight/7.03;
  //new hight
  static double height10 = screenSizeHeight/84.4;
  static double height15 = screenSizeHeight/56.27;
  static double height20 = screenSizeHeight/42.2;
  static double height30 = screenSizeHeight/28.13;
  static double height45 = screenSizeHeight/18.76;

  //dynamic width padding and margin
  static double width10 = screenSizeHeight/84.4;
  static double width15 = screenSizeHeight/56.27;
  static double width20 = screenSizeHeight/42.2;
  static double width30 = screenSizeHeight/28.13;

  //radius
  static double radius15 = screenSizeHeight/56.27;
  static double radius20 = screenSizeHeight/42.2;
  static double radius30 = screenSizeHeight/28.13;

}
