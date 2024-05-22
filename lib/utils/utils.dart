import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static toastMessages(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static flushBarMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        duration: const Duration(seconds: 2),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.bounceInOut,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        icon: const Icon(
          Icons.dangerous_outlined,
          color: Colors.redAccent,
        ),
        message: message,
      )..show(context),
    );
  }
}
