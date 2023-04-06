import 'dart:async';

class Debouncer<T> {
  Debouncer({
    required this.duration,
    required this.action,
    required T initialState,
  }) : _state = initialState;

  /// Debouncer for searching purposes, with predefined duration.
  Debouncer.search({
    required this.action,
    required T initialState,
  })  : duration = Duration(milliseconds: 350),
        _state = initialState;

  /// Duration that has to pass after each [run] before [action] is called.
  final Duration duration;

  /// Action called when all events are debounced.
  ///
  /// [value] is a last value passed to [run] method.
  final void Function(T value) action;

  Timer? _timer;

  T _state;

  /// Changes debouncer state (with debouncing).
  void changeState(T newState) async {
    final Timer? timer = _timer;
    if (timer != null) {
      timer.cancel();
    }

    _timer = Timer(
      duration,
      () => _action(newState),
    );
  }

  /// Changes debouncer state immediately (without debouncing).
  ///
  /// Cancels all previous changes.
  void changeStateImmediately(T newState) {
    final Timer? timer = _timer;
    if (timer != null) {
      timer.cancel();
    }

    _action(newState);
  }

  /// Current debouncer state.
  T get state {
    return _state;
  }

  void _action(T value) {
    _state = value;
    action(value);
  }
}
