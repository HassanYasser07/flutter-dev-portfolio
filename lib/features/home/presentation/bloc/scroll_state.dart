import 'package:equatable/equatable.dart';

enum HomeSection { hero, about, skills, projects, experience, contact }

class ScrollState extends Equatable {
  const ScrollState({this.active = HomeSection.hero});

  final HomeSection active;

  ScrollState copyWith({HomeSection? active}) {
    return ScrollState(active: active ?? this.active);
  }

  @override
  List<Object?> get props => [active];
}
