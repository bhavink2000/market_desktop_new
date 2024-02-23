import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class CustomScrollBar extends StatelessWidget {
  CustomScrollBar({
    Key? key,
    required this.bgColor,
    required this.child,
  }) : super(key: key);

  Color bgColor;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      interactive: false,
      thumbColor: bgColor,
      thickness: 10,
      radius: const Radius.circular(5),
      thumbVisibility: true,
      child: child,
    );
  }

  // String? fontFamily;
}
