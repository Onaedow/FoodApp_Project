
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/screens/search/search_result_widget.dart';
import 'package:shopping_app/screens/search/widget/search_field.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/search_product_controller.dart';
import '../../uitls/app_dimensions.dart';
import '../../uitls/styles.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(Get.find<SearchProductController>().isSearchMode) {
          return true;
        }else {
          Get.find<SearchProductController>().setSearchMode(true);
          return false;
        }
      },
      child: Scaffold(
        body: SafeArea(child: Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          child: GetBuilder<SearchProductController>(builder: (searchController) {
            _searchController.text = searchController.searchText;
            return Column(children: [

              Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Row(children: [
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(child: SearchField(
                  controller: _searchController,
                  hint: 'search_for_food'.tr,
                  suffixIcon: !searchController.isSearchMode ? Icons.filter_list : Icons.search,
                  iconPressed: () => _actionSearch(searchController, false),
                  onSubmit: (text) => _actionSearch(searchController, true),
                )),
                CustomButton(
                  onPressed: () => searchController.isSearchMode ? Get.back() : searchController.setSearchMode(true),
                  buttonText: 'cancel'.tr,
                  transparent: true,
                  width: 80,
                ),
              ]))),

              Expanded(child: searchController.isSearchMode ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                child: Center(child: SizedBox(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("In search mode")
                ]))),
              ) : SearchResultWidget(searchText: _searchController.text.trim())),

            ]);
          }),
        )),
      ),
    );
  }

  void _actionSearch(SearchProductController searchController, bool isSubmit) {
    if(searchController.isSearchMode || isSubmit) {
      if(_searchController.text.trim().isNotEmpty) {
        searchController.searchData(_searchController.text.trim());
      }else {
        showCustomSnackBar('Type is a keyword to search for food');
      }
    }
  }
}
