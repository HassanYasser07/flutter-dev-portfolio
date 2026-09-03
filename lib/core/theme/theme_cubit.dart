import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({ThemeMode initial = ThemeMode.dark}) : super(initial);

  bool get isDark => state == ThemeMode.dark;

  void toggle() {
    emit(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  void setMode(ThemeMode mode) {
    if (mode == state) return;
    emit(mode);
  }
}
