import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/utils/locator.dart';

void main() {
  group(MyApp, () {
    setUp(() {
      setupLocator();
    });
    testWidgets('Counter increments smoke test', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await expectLater(
          find.byType(MyApp), matchesGoldenFile('goldens/no_todos.png'));

      // Tap the add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter text in the dialog
      await tester.enterText(find.byType(TextField), 'Test Todo');
      await tester.pumpAndSettle();

      // Tap the Add button in the dialog
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Find the checkbox and verify initial state
      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);
      expect(tester.widget<Checkbox>(checkbox).value, false);

      // Tap the checkbox
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      // Tap the add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter text in the dialog
      await tester.enterText(find.byType(TextField), 'Test Todo 2');
      await tester.pumpAndSettle();

      // Tap the Add button in the dialog
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Toggle the show completed todos
      await tester.tap(find.text('Show Done'));
      await tester.pumpAndSettle();

      await expectLater(
          find.byType(MyApp), matchesGoldenFile('goldens/two_todos.png'));
    });
  });
}
