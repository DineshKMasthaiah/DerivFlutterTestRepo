import 'package:flutter/material.dart';

class PTBaseScreen{
  ///Returns screen size for the callers to calculate related height and width for the Widgets
  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}