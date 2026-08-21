import 'package:flutter_test/flutter_test.dart';
import 'package:usina_app/main.dart';

void main() {
  testWidgets('app inicializa sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(const UsinaApp());
    expect(find.text('fieldnode'), findsOneWidget);
  });
}
