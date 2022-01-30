import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_buyer_guide/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('integration test',
  (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.byIcon(Icons.sort));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));


    await tester.tap(find.text('Rating (5 to 1)'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.byIcon(Icons.favorite_outline).first);
    await tester.pumpAndSettle();
    await expectLater((tester.firstWidget(find.byType(Icon)) as Icon).color, Colors.redAccent);

    await tester.tap(find.byIcon(Icons.favorite_outline).last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text('Favorite'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    await tester.drag(find.byType(Dismissible).at(1), const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.byType(Dismissible).first);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
  });
}
