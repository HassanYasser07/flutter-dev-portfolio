import 'package:equatable/equatable.dart';

import '../../data/models/about_model.dart';

enum AboutStatus { initial, loading, loaded, error }

class AboutState extends Equatable {
  const AboutState({
    this.status = AboutStatus.initial,
    this.about,
    this.errorMessage,
  });

  final AboutStatus status;
  final AboutModel? about;
  final String? errorMessage;

  AboutState copyWith({
    AboutStatus? status,
    AboutModel? Function()? about,
    String? errorMessage,
  }) {
    return AboutState(
      status: status ?? this.status,
      about: about != null ? about() : this.about,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, about, errorMessage];
}
