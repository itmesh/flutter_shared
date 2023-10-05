import 'package:flutter/foundation.dart';

class ExpandPlayerController {
  ExpandPlayerController({
    bool initialExpanded = false,
  }) : _isExpanded = ValueNotifier<bool>(initialExpanded);

  final ValueNotifier<bool> _isExpanded;

  void dispose() {
    _isExpanded.dispose();
  }

  void expand() {
    _isExpanded.value = true;
  }

  void hide() {
    _isExpanded.value = false;
  }

  void toggleExpandPlayer(bool value) {
    if (value == _isExpanded.value) {
      return;
    }

    if (_isExpanded.value) {
      hide();
    } else {
      expand();
    }
  }

  ValueListenable<bool> get isExpanded {
    return _isExpanded;
  }
}
