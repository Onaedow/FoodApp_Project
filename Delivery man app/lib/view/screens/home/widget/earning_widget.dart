import 'package:the_best_food/helper/price_converter.dart';
import 'package:the_best_food/util/dimensions.dart';
import 'package:the_best_food/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class EarningWidget extends StatelessWidget {
  final String title;
  final double amount;
  EarningWidget({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Text(
        title,
        style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).cardColor),
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
      amount != null ? Text(
        PriceConverter.convertPrice(amount),
        style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).cardColor),
        maxLines: 1, overflow: TextOverflow.ellipsis,
      ) : Shimmer(
        duration: Duration(seconds: 2),
        enabled: amount == null,
        color: Colors.grey[500]!,
        child: Container(height: 20, width: 40, color: Colors.white),
      ),
    ]));
  }
}
