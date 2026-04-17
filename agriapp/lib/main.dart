import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/veiculo/presentation/blocs/veiculo_bloc.dart';
import 'features/veiculo/presentation/pages/veiculo_list_page.dart';

void main() async {
  // Garante que o binding do Flutter esteja pronto antes de carregar a infra
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Service Locator (Dio, Services, Repositories)
  await di.init();

  runApp(const AgriApp());
}

class AgriApp extends StatelessWidget {
  const AgriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => di.sl<VeiculoBloc>())],
      child: MaterialApp(
        title: 'AgriApp — Gestão de Frotas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        home: const VeiculoListPage(),
      ),
    );
  }
}
