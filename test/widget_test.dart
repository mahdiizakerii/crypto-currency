import 'package:crypto_currency/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens the login page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Enter Passcode'), findsOneWidget);
  });
}
