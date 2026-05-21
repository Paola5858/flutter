import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/background/sync_manager.dart';
import 'core/di/injection_container.dart' as di;
import 'core/local/hive_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_bloc_observer.dart';
import 'features/veiculo/presentation/blocs/veiculo_bloc.dart';
import 'features/veiculo/presentation/pages/veiculo_list_page.dart';
import 'features/marca/presentation/blocs/marca_bloc.dart';
import 'features/marca/presentation/pages/marca_screen.dart';
import 'features/marca/presentation/pages/marca_form_screen.dart';
import 'features/modelo/presentation/pages/modelo_screen.dart';
import 'features/modelo/presentation/pages/modelo_form_screen.dart';
import 'features/home/presentation/pages/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await di.sl<HiveService>().init();

  final dsn = const String.fromEnvironment('SENTRY_DSN', defaultValue: '');
  if (dsn.isNotEmpty) {
    await SentryFlutter.init((options) {
      options.dsn = dsn;
      options.tracesSampleRate = 0.1;
      options.environment = const String.fromEnvironment(
        'FLUTTER_ENV',
        defaultValue: 'production',
      );
    }, appRunner: () => _runApp());
  } else {
    await _runApp();
  }
}

Future<void> _runApp() async {
  if (!const bool.fromEnvironment('FLUTTER_TEST')) {
    await SyncManager.initialize();
  }

  Bloc.observer = AppBlocObserver();
  runApp(const AgriApp());
}

class AgriApp extends StatelessWidget {
  const AgriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<VeiculoBloc>()),
        BlocProvider(create: (_) => di.sl<MarcaBloc>()),
      ],
      child: MaterialApp(
        title: 'AgriApp — Gestão de Frotas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (_) => const HomeScreen(),
          '/veiculo': (_) => const VeiculoListPage(),
          '/marca': (_) => const MarcaScreen(),
          '/marca/form': (_) => const MarcaFormScreen(),
          '/modelo': (_) => const ModeloScreen(),
          '/modelo/form': (_) => const ModeloFormScreen(),
        },
      ),
    );
  }
}
