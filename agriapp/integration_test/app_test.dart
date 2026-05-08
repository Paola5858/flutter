import 'package:agriapp/main.dart' as app;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('fluxo completo de veiculo', (WidgetTester tester) async {
    if (kIsWeb) {
      // Web environment currently skips device-level integrations.
    }

    await app.main();
    await tester.pumpAndSettle();

    final addButton = find.byKey(const Key('add_veiculo_btn'));
    expect(addButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.text('Novo Veículo'), findsOneWidget);
  });
}
