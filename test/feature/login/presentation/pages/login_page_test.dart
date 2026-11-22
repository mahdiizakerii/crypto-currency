import 'package:crypto_currency/feature/login/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('enters and deletes digits without showing the passcode', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.text('Enter Passcode'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('digit-1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('digit-2')));
    await tester.pump();

    expect(find.bySemanticsLabel('Digit 1 entered'), findsOneWidget);
    expect(find.bySemanticsLabel('Digit 2 entered'), findsOneWidget);
    expect(find.text('12'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('delete-digit')));
    await tester.pump();

    expect(find.bySemanticsLabel('Digit 1 entered'), findsOneWidget);
    expect(find.bySemanticsLabel('Digit 2 not entered'), findsOneWidget);
  });
}
