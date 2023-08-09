import 'package:equatable/equatable.dart';

class UserError extends Equatable {
  const UserError({
    required this.message,
    this.code,
  });

  final String message;
  final int? code;

  @override
  List<Object?> get props => <Object?>[
        message,
        code,
      ];
}
