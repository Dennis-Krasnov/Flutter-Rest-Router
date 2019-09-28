import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets("Navigates to static path", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text("/"), findsOneWidget);

    await tester.tap(find.byType(RaisedButton).first);
    await tester.pumpAndSettle();
    expect(find.text("path is /items"), findsOneWidget);

    await tester.tap(find.bySemanticsLabel("Back"));
    await tester.pumpAndSettle();
    expect(find.text("/"), findsOneWidget);
  });

  testWidgets("Navigates to variable path", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text("/"), findsOneWidget);

    await tester.tap(find.byType(RaisedButton).at(1));
    await tester.pumpAndSettle();
    expect(find.text("sum is 42"), findsOneWidget);

    await tester.tap(find.bySemanticsLabel("Back"));
    await tester.pumpAndSettle();
    expect(find.text("/"), findsOneWidget);
  });

  testWidgets("Navigates to 404", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text("/"), findsOneWidget);

    await tester.tap(find.byType(RaisedButton).at(2));
    await tester.pumpAndSettle();
    expect(find.text("/itemz is 404"), findsOneWidget);

    await tester.tap(find.bySemanticsLabel("Back"));
    await tester.pumpAndSettle();
    expect(find.text("/"), findsOneWidget);
  });
}
