import 'package:flutter_bloc/flutter_bloc.dart';

class ImCubit<T> extends Cubit<T> {
  ImCubit(super.initialState);

  @override
  void emit(T state) {
    if (isClosed) {
      return;
    }

    super.emit(state);
  }
}
