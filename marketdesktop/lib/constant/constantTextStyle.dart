import 'package:flutter/cupertino.dart';

import 'color.dart';
import 'font_family.dart';

class TextStyles {
  var textFieldText = TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().fontColor);
  var textFieldFocusText = TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().fontColor);
  var drawerTitleText = TextStyle(
    fontSize: 14,
    color: AppColors().whiteColor,
    fontFamily: CustomFonts.family1Medium,
  );
  var navTitleText = TextStyle(
    fontSize: 16,
    color: AppColors().blueColor,
    fontFamily: CustomFonts.family1SemiBold,
  );
}
