import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/constants/tags.dart';
import 'package:flutter_todo/date_service.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/todo/todo_page.dart';
import 'package:flutter_todo/utils/locator.dart';

void main() {
  group(MyApp, () {
    setUp(() {
      // Register the DateService can be a fake if needed
      locator.registerSingleton(DateService());
    });

    tearDown(() {
      // Reset the GetIt instance before each test
      locator.reset();
    });

    testWidgets('Initial empty state golden test', tags: TestTag.golden,
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TodoPage()));

      await expectLater(
          find.byType(TodoPage), matchesGoldenFile('goldens/no_todos.png'));
    });

    testWidgets('Two todos with completed item shown golden test',
        tags: TestTag.golden, (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TodoPage()));

      // Add first todo and mark as complete
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Test Todo');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      final checkbox = find.byType(Checkbox);
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      // Add second todo
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Test Todo 2');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Show completed todos
      await tester.tap(find.text('Show Done'));
      await tester.pumpAndSettle();

      await expectLater(
          find.byType(TodoPage), matchesGoldenFile('goldens/two_todos.png'));
    });
  });
}
