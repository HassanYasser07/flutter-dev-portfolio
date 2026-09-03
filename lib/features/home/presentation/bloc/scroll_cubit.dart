import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/scroll_utils.dart';
import 'scroll_state.dart';

class ScrollCubit extends Cubit<ScrollState> {
  ScrollCubit() : super(const ScrollState());

  void setActive(HomeSection section) {
    if (state.active == section) return;
    emit(state.copyWith(active: section));
  }
}

/// Provides section [GlobalKey]s and the page [ScrollController] to the nav.
class HomeAnchorScope extends InheritedWidget {
  const HomeAnchorScope({
    super.key,
    required this.controller,
    required this.keys,
    required super.child,
  });

  final ScrollController controller;
  final Map<HomeSection, GlobalKey> keys;

  static HomeAnchorScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeAnchorScope>();
  }

  Future<void> scrollTo(HomeSection section) {
    final key = keys[section];
    if (key == null) return Future<void>.value();
    return ScrollUtils.toKey(key);
  }

  @override
  bool updateShouldNotify(HomeAnchorScope oldWidget) {
    return controller != oldWidget.controller || keys != oldWidget.keys;
  }
}
