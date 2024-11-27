import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/constants/tags.dart';
import 'package:flutter_todo/date_service.dart';
import 'package:flutter_todo/todo/todo_page.dart';
import 'package:flutter_todo/utils/locator.dart';

class GoldenDiffComparator extends LocalFileComparator {
  GoldenDiffComparator(
    String testFile, {
    required this.tolerancePercentage,
  }) : super(Uri.parse(testFile));

  /// Customise your threshold here in percentage
  /// Golden tests will pass if the pixel difference is equal to or below
  /// [tolerancePercentage]%
  final double tolerancePercentage;
  double get _kGoldenDiffTolerance => tolerancePercentage / 100;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final ComparisonResult result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent > _kGoldenDiffTolerance) {
      final String error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    if (!result.passed) {
      debugPrint(
        'A difference of ${result.diffPercent * 100}% was found when comparing $golden.',
      );
    }
    return result.passed ||
        (result.diffPercent <= _kGoldenDiffTolerance && Platform.isLinux);
  }
}

Future<void> expectGoldenMatches(
  Finder actual,
  String goldenFileKey, {
  String? reason,
  double? tolerancePercentage,
}) {
  final goldenPath = 'goldens/$goldenFileKey';
  goldenFileComparator = GoldenDiffComparator(
    '${(goldenFileComparator as LocalFileComparator).basedir}/$goldenFileKey',
    tolerancePercentage: tolerancePercentage ?? 0.5,
  );

  return expectLater(
    actual,
    matchesGoldenFile(goldenPath),
    reason: reason,
  );
}

void main() {
  group(TodoPage, () {
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

      await expectGoldenMatches(
        find.byType(TodoPage),
        'no_todos.png',
        tolerancePercentage: 0.25,
      );
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

      await expectGoldenMatches(
        find.byType(TodoPage),
        'two_todos.png',
        tolerancePercentage: 0.4,
      );
    });
  });
}
