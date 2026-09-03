import 'package:equatable/equatable.dart';

enum CvStatus { initial, success, error }

class CvState extends Equatable {
  const CvState({
    this.status = CvStatus.initial,
    this.message,
  });

  final CvStatus status;
  final String? message;

  CvState copyWith({
    CvStatus? status,
    String? message,
  }) {
    return CvState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
