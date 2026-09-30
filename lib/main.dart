import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/localization/app_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bqxdkhbwpaaundjeagoc.supabase.co',
    publishableKey: 'sb_publishable_bGPh3CJKIBbcrqZaoZRzXg_IRKb1TuQ',
  );
  Bloc.observer = AppBlocObserver();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: AppLocalization.supportedLocales,
      path: AppLocalization.translationsPath,
      fallbackLocale: AppLocalization.fallbackLocale,
      startLocale: AppLocalization.fallbackLocale,
      child: const PortfolioApp(),
    ),
  );
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint('${bloc.runtimeType} $change');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} $error');
    super.onError(bloc, error, stackTrace);
  }
}
