import 'package:demo/todo/todo.dart';
import 'package:demo/todo/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should add a todo when using the add button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TodoPage(),
      ),
    );

    // Verify initial state has no todos
    expect(find.byType(ListTile), findsNothing);

    // Tap the add button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Enter text in the dialog
    await tester.enterText(find.byType(TextField), 'Test Todo');
    await tester.pumpAndSettle();

    // Tap the Add button in the dialog
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify the todo was added
    expect(find.text('Test Todo'), findsOneWidget);
  });

  testWidgets('should toggle todo completion status',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TodoPage(),
      ),
    );

    // Add a todo
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Test Todo');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Find the checkbox and verify initial state
    final checkbox = find.byType(Checkbox);
    expect(checkbox, findsOneWidget);
    expect(tester.widget<Checkbox>(checkbox).value, false);

    // Tap the checkbox
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // Verify the checkbox is no longer rendered after completion
    expect(checkbox, findsNothing);
  });
}
