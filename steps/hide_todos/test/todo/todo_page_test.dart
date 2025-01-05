import 'package:demo/date_service.dart';
import 'package:demo/todo/todo.dart';
import 'package:demo/todo/todo_page.dart';
import 'package:demo/utils/locator.dart';
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

  testWidgets('TodoPage uses ValueListenableBuilder with ViewModel',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: TodoPage()));

    // Assert
    expect(
      find.byWidgetPredicate(
        (widget) => widget is ValueListenableBuilder && 
                    widget.valueListenable is ValueNotifier<List<Todo>>,
      ),
      findsOneWidget,
      reason: 'TodoPage should use ValueListenableBuilder to listen to ViewModel changes from the notifier',
    );

    // Verify ListView.builder exists
    expect(
      find.byType(ListView),
      findsOneWidget,
      reason: 'ValueListenableBuilder should contain ListView to display todos',
    );
  });

  testWidgets('TodoPage uses ValueListenableBuilder with dateNotifier',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: TodoPage()));

    // Assert
    expect(
      find.byWidgetPredicate(
        (widget) => widget is ValueListenableBuilder && 
                    widget.valueListenable is ValueNotifier<DateTime>,
      ),
      findsOneWidget,
      reason: 'TodoPage should use ValueListenableBuilder to listen to date changes from the notifier',
    );

    // Verify the date display is in AppBar
    expect(
      find.ancestor(
        of: find.byWidgetPredicate(
          (widget) => widget is ValueListenableBuilder &&
                      widget.valueListenable is ValueNotifier<DateTime>,
        ),
        matching: find.byType(AppBar),
      ),
      findsOneWidget,
      reason: 'Date ValueListenableBuilder should be within AppBar',
    );
  });
}
