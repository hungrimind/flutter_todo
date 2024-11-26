import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/main.dart';
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
  group(MyApp, () {
    setUp(() {
      setupLocator();
    });
    testWidgets('Add two todos and show completed golden test',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await expectGoldenMatches(find.byType(MyApp), 'no_todos.png');

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

      await expectGoldenMatches(find.byType(MyApp), 'two_todos.png');
    });
  });
}
