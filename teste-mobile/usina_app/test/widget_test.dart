import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:usina_app/main.dart';
import 'package:usina_app/screens/cadastros/cadastro_indicador.dart';
import 'package:usina_app/screens/cadastros/cadastro_usuario.dart';

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
    expect(find.text('funcionário'), findsOneWidget);
    expect(find.text('usuário'), findsOneWidget);
    expect(find.text('tipo de medição'), findsOneWidget);
    expect(find.text('parâmetro'), findsOneWidget);
  });

  testWidgets('menu abre os cadastros especializados', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(UsinaApp(dashboard: criarDashboardDemo()));

    await tester.tap(find.byTooltip('abrir menu principal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('cadastro'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -360));
    await tester.pumpAndSettle();
    await tester.tap(find.text('funcionário'));
    await tester.pumpAndSettle();
    expect(find.text('novo funcionário'), findsOneWidget);

    await tester.tap(find.byTooltip('voltar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('abrir menu principal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('cadastro'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -360));
    await tester.pumpAndSettle();
    await tester.tap(find.text('usuário'));
    await tester.pumpAndSettle();
    expect(find.text('novo usuário'), findsOneWidget);
  });

  testWidgets('rotas nomeadas mantêm acesso aos cadastros genéricos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(UsinaApp(dashboard: criarDashboardDemo()));

    for (final cadastro in const [
      'unidade',
      'setor',
      'equipamento',
      'tipo de medição',
      'parâmetro',
    ]) {
      await tester.tap(find.byTooltip('abrir menu principal'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('cadastro'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(cadastro));
      await tester.pumpAndSettle();
      await tester.tap(find.text(cadastro));
      await tester.pumpAndSettle();

      expect(find.text('novo $cadastro'), findsOneWidget);
      await tester.tap(find.byTooltip('voltar'));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('cadastro de usuário expõe estados de imagem', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CadastroUsuarioPage()));
    await tester.pumpAndSettle();

    expect(
      find.text('adicione uma foto para personalizar seu perfil'),
      findsOneWidget,
    );
    await tester.tap(find.byIcon(Icons.add_a_photo_outlined));
    await tester.pumpAndSettle();

    expect(find.text('galeria'), findsOneWidget);
    expect(find.text('câmera'), findsOneWidget);
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
