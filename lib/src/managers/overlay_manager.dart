import 'package:flutter/material.dart';

class FSOverlayManager {
  static final List<OverlayEntry> _entries = <OverlayEntry>[];

  static void add(OverlayEntry entry) {
    _entries.add(entry);
  }

  static void clearAll() {
    for (int i = 0; i < _entries.length; i++) {
      _entries[i].remove();
    }

    _entries.clear();
  }

  static void remove(OverlayEntry entry) {
    _entries.remove(entry);
  }
}
