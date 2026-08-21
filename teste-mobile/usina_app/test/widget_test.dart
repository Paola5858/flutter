import 'package:flutter_test/flutter_test.dart';
import 'package:usina_app/main.dart';

void main() {
  testWidgets('dashboard de extração inicializa sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(UsinaApp(dashboard: criarDashboardDemo()));
    expect(find.text('usina aurora'), findsOneWidget);
    expect(find.text('indicadores'), findsOneWidget);
    expect(find.text('produção de açúcar'), findsOneWidget);
  });
}
