import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:usina_app/main.dart';
import 'package:usina_app/screens/cadastros/cadastro_indicador.dart';

void main() {
  testWidgets('dashboard de extração inicializa sem erros', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(UsinaApp(dashboard: criarDashboardDemo()));
    expect(find.text('usina aurora'), findsOneWidget);
    expect(find.text('indicadores'), findsOneWidget);
    expect(find.text('produção de açúcar'), findsOneWidget);
  });

  testWidgets('menu mantém acesso ao cadastro de indicador', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(UsinaApp(dashboard: criarDashboardDemo()));

    await tester.tap(find.byTooltip('abrir menu principal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('cadastro'));
    await tester.pumpAndSettle();

    expect(find.text('indicador'), findsOneWidget);
    expect(find.text('unidade'), findsOneWidget);
    expect(find.text('equipamento'), findsOneWidget);
  });

  testWidgets('cadastro de indicador preserva validações obrigatórias', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CadastroIndicadorPage()));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('salvar indicador'));
    await tester.pumpAndSettle();

    expect(find.text('dê um nome para esse indicador'), findsOneWidget);
    expect(
      find.text('explique o que esse indicador acompanha'),
      findsOneWidget,
    );
    expect(find.text('informe a url da fonte do indicador'), findsOneWidget);
  });
}
