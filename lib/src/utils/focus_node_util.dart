import 'package:flutter/cupertino.dart';

class FocusNodeUtil {
  static void clearFocus(BuildContext context) {
    final FocusScopeNode focusNode = FocusScope.of(context);

    if (!focusNode.hasPrimaryFocus) focusNode.focusedChild?.unfocus();
  }
}
