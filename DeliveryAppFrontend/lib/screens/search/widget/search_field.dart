
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../uitls/app_dimensions.dart';
import '../../../uitls/styles.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData suffixIcon;
  final VoidCallback iconPressed;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  SearchField({required this.controller,
    required this.hint,
    required this.suffixIcon,
    required this.iconPressed,
     this.onSubmit,
     this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), borderSide: BorderSide.none),
        filled: true, fillColor: Theme.of(context).cardColor,
        isDense: true,
        suffixIcon: IconButton(
          onPressed: iconPressed,
          icon: Icon(suffixIcon),
        ),
      ),
      onSubmitted: onSubmit,
      onChanged: onChanged,
    );
  }
}
