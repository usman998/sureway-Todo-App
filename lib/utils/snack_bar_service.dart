

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class SnackBarService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showError({String? message}) {
    final msg = message ?? "Something went wrong. Try again later.";
    _showSnackBar(
      message: msg,
      color: Color(0xffffd6da),
      icon: "assets/error_info.svg",
    );
  }

  static void showSuccess(String successMessage) {
    _showSnackBar(
      message: successMessage,
      color: Color(0xffd1f5da),
      icon: "assets/success.svg",
    );
  }

  static void _showSnackBar({
    required String message,
    required Color color,
    required String icon,
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12,
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff0a0a1e),
                fontWeight: FontWeight.w400,
                letterSpacing: 0.32,
                height: 1.40000,
              ),
            ),
          ),
        ],
      ),
    );

    messengerKey.currentState?.showSnackBar(snackBar);
  }
}
