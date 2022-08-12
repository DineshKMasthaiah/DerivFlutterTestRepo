import 'package:flutter/material.dart';
/// A class that returns global data provider and Global context
class PTAppGlobalKey {
  static  GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

  ///
  /// Whenever there is no context available for caller to call GlobalAppDataProvider.of(context),
  /// the caller can use this. its like global application context
  static BuildContext getGlobalContext() {
    return globalKey
        .currentContext!;
  }
}
