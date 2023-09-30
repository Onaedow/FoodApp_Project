
import 'package:flutter/cupertino.dart';

import '../models/product.dart';
import '../uitls/app_dimensions.dart';
import 'no_data_found.dart';

class ProductView extends StatelessWidget {
  final List<Product> products;

  final bool isRestaurant;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String? noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  ProductView({ required this.products, required this.isRestaurant, this.isScrollable = false,
    this.shimmerLength = 20, this.padding = const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), this.noDataText,
    this.isCampaign = false, this.inRestaurantPage = false});

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;
   {
      _isNull = products == null;
      if(!_isNull) {
        _length = products.length;
      }
    }

    return !_isNull ? _length > 0 ? GridView.builder(
      key: UniqueKey(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
        mainAxisSpacing:  0.01,
        childAspectRatio:  4,
        crossAxisCount: 2,
      ),
      physics: isScrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
      shrinkWrap: isScrollable ? false : true,
      itemCount: _length,
      padding: padding,
      itemBuilder: (context, index) {
        return Container(child:Text("food search"));
      },
    ) : NoDataScreen(
      text: noDataText != null ? noDataText! : 'no_food_available',
    ) : GridView.builder(
      key: UniqueKey(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
        mainAxisSpacing:  0.01,
        childAspectRatio:  4,
        crossAxisCount:  2,
      ),
      physics: isScrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
      shrinkWrap: isScrollable ? false : true,
      itemCount: shimmerLength,
      padding: padding,
      itemBuilder: (context, index) {
        return Container(child:Text("Shimmer"));
        //ProductShimmer(isEnabled: _isNull, isRestaurant: isRestaurant, hasDivider: index != shimmerLength-1);
      },
    );
  }
}
