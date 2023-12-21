import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:marketdesktop/screens/UserDetailPopups/FilterPopup/filterPopUpController.dart';

import '../../../constant/index.dart';

import '../../BaseController/baseController.dart';

class FilterPopUpScreen extends BaseView<FilterPopUpController> {
  const FilterPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: Column(
          children: [
            Row(
              children: [],
            ),
          ],
        ));
  }
}
