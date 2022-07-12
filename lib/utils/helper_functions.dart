
import 'package:flutter/material.dart';

class HelperFunctions {

  static showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

}