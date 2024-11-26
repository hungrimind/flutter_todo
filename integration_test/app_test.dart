import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/utils/locator.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    setUp(() {
      setupLocator();
    });

    tearDown(() {
      // Reset the GetIt instance before each test
      locator.reset();
    });

    testWidgets('full todo workflow test', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      // Add first todo
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'First Todo');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Add second todo
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'Second Todo');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Verify both todos are visible
      expect(find.text('First Todo'), findsOneWidget);
      expect(find.text('Second Todo'), findsOneWidget);

      // Complete first todo
      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();

      // Verify only incomplete todo is visible
      expect(find.text('First Todo'), findsNothing);
      expect(find.text('Second Todo'), findsOneWidget);

      // Show completed todos again
      await tester.tap(find.text('Show Done'));
      await tester.pump();

      // Verify both todos are visible again
      expect(find.text('First Todo'), findsOneWidget);
      expect(find.text('Second Todo'), findsOneWidget);

      // Delete first todo using long press
      await tester.longPress(find.text('First Todo'));
      await tester.pump();

      // Verify first todo is deleted
      expect(find.text('First Todo'), findsNothing);
      expect(find.text('Second Todo'), findsOneWidget);
    });
  });
}
