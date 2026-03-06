import 'package:flutter_test/flutter_test.dart';
import 'package:agroapp/main.dart';

void main() {
  testWidgets('HomePage exibe botão VER DADOS DO SOLO', (WidgetTester tester) async {
    await tester.pumpWidget(const AgroControlApp());
    
    expect(find.text('VER DADOS DO SOLO'), findsOneWidget);
  });

  testWidgets('HomePage exibe título AgroControl', (WidgetTester tester) async {
    await tester.pumpWidget(const AgroControlApp());
    
    expect(find.text('AgroControl'), findsOneWidget);
  });

  testWidgets('HomePage exibe status da máquina', (WidgetTester tester) async {
    await tester.pumpWidget(const AgroControlApp());
    
    expect(find.textContaining('Status:'), findsOneWidget);
  });
}
