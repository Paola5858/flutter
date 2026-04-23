// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agriapp/main.dart';
import 'package:agriapp/features/veiculo/presentation/pages/veiculo_list_page.dart';
import 'package:agriapp/core/di/injection_container.dart' as di;

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await di.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const AgriApp());
    await tester.pumpAndSettle();

    // Verify that the page loads without crashing (smoke test)
    expect(find.byType(VeiculoListPage), findsOneWidget);
  });
}
