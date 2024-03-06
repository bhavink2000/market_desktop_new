import 'package:flutter/material.dart';

import '../main.dart';

class AppColors {
  var footerColor = currentDarkModeOn ? Colors.black : Colors.white;
  var fontColor = currentDarkModeOn ? const Color.fromRGBO(240, 240, 240, 1.0) : const Color.fromRGBO(48, 53, 53, 1.0);
  var fontTextColor = currentDarkModeOn ? const Color.fromRGBO(240, 240, 240, 1.0) : const Color.fromRGBO(155, 155, 173, 1.0);
  var borderColor = const Color.fromRGBO(39, 94, 224, 1.0);
  var grayBorderColor = currentDarkModeOn ? const Color.fromRGBO(235, 236, 238, 0.5) : const Color.fromRGBO(235, 235, 235, 1.0);
  var bgColor = currentDarkModeOn ? const Color.fromRGBO(28, 28, 28, 1.0) : const Color.fromRGBO(254, 255, 254, 1.0);
  var headerBgColor = currentDarkModeOn ? const Color.fromRGBO(17, 17, 17, 1.0) : const Color.fromRGBO(235, 236, 237, 1);
  // var blueColor = const Color.fromRGBO(39, 94, 224, 1.0);
  // var redColor = const Color.fromRGBO(206, 90, 82, 1);
  var blueColor = const Color.fromRGBO(33, 115, 253, 1.0);
  var redColor = const Color.fromRGBO(255, 0, 0, 1);
  var pinkColor = const Color(0xffFB7CD7);
  var skyBlueColor = const Color(0xff87CEEB);

  // var greenColor = const Color.fromRGBO(67, 154, 67, 1.0);
  var greenColor = const Color.fromRGBO(0, 0, 255, 1.0);
  var whiteColor = Colors.white;
  var grayColor = const Color.fromRGBO(48, 53, 53, 1.0);
  var placeholderColor = const Color.fromRGBO(161, 163, 176, 1.0);
  var backgroundColor = const Color.fromRGBO(238, 250, 255, 1);

  var darkText = currentDarkModeOn ? Colors.white : const Color.fromRGBO(66, 66, 79, 1.0);
  var lightText = currentDarkModeOn ? Colors.white : const Color.fromRGBO(155, 155, 173, 1);
  var lightOnlyText = const Color.fromRGBO(155, 155, 173, 1);
  var grayBg = const Color.fromRGBO(235, 236, 237, 1);
  var switchColor = currentDarkModeOn ? Colors.black : const Color.fromRGBO(155, 155, 173, 1);
  var greenColors = const Color.fromRGBO(103, 173, 91, 1);
  var grayLightLine = currentDarkModeOn ? const Color.fromARGB(255, 96, 96, 96) : const Color.fromRGBO(235, 235, 235, 1);
  var contentBg = currentDarkModeOn ? const Color.fromARGB(255, 31, 33, 33) : const Color.fromRGBO(250, 250, 250, 1);
  var slideGrayBG = const Color.fromRGBO(224, 224, 224, 1);
  var iconsColor = const Color.fromRGBO(57, 57, 57, 1);
  var gradientStart = const Color.fromRGBO(162, 196, 254, 1);
  var gradientEnd = const Color.fromRGBO(232, 240, 255, 1);
  //235, 236, 237, 1

  var customGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color.fromRGBO(162, 196, 254, 1), Color.fromRGBO(232, 240, 255, 1)],
  );
  var customReverseGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color.fromRGBO(232, 240, 255, 1), Color.fromRGBO(162, 196, 254, 1)],
  );
}
