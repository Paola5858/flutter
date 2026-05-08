import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    Sentry.captureException(error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
