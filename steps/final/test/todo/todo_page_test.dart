import 'package:demo/date_service.dart';
import 'package:demo/todo/todo.dart';
import 'package:demo/todo/todo_page.dart';
import 'package:demo/utils/locator.dart';
import 'package:demo/utils/valuelistenablebuilder3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    // Register the DateService can be a fake if needed
    locator.registerSingleton(DateService());
  });

  tearDown(() {
    // Reset the GetIt instance before each test
    locator.reset();
  });

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

  testWidgets('TodoPage uses ValueListenableBuilder3 with all notifiers',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: TodoPage()));

    // Assert
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ValueListenableBuilder3<bool, DateTime, List<Todo>>,
      ),
      findsOneWidget,
      reason:
          'TodoPage should use ValueListenableBuilder3 to listen to all notifier changes',
    );

    // Verify ListView.builder exists
    expect(
      find.byType(ListView),
      findsOneWidget,
      reason:
          'ValueListenableBuilder3 should contain ListView to display todos',
    );
  });

  testWidgets('should toggle visibility of completed todos',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TodoPage(),
      ),
    );

    // Add first todo
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Todo 1');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Add second todo
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Todo 2');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify both todos are visible
    expect(find.text('Todo 1'), findsOneWidget);
    expect(find.text('Todo 2'), findsOneWidget);

    // Complete first todo
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    // Verify completed todo is hidden by default
    expect(find.text('Todo 1'), findsNothing);
    expect(find.text('Todo 2'), findsOneWidget);

    // Show completed todos
    await tester.tap(find.text('Show Done'));
    await tester.pumpAndSettle();

    // Verify both todos are visible again
    expect(find.text('Todo 1'), findsOneWidget);
    expect(find.text('Todo 2'), findsOneWidget);

    // Hide completed todos
    await tester.tap(find.text('Hide Done'));
    await tester.pumpAndSettle();

    // Verify completed todo is hidden again
    expect(find.text('Todo 1'), findsNothing);
    expect(find.text('Todo 2'), findsOneWidget);
  });
}
