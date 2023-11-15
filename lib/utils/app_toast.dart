import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyAppToast {
  static Future<bool?> showAppToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM_RIGHT,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 1,
      webBgColor: "black",
    );
    return Future.value(false);
  }
}
