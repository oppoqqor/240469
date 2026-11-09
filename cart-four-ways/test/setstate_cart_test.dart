import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cart/setstate/cart_page_setstate.dart';

void main() {
  testWidgets('setState cart adds Keyboard twice, applies SAVE10, total reads 88.20', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SetStateCartPage()));

    final keyboardChip = find.text('Keyboard · 49');
    await tester.tap(keyboardChip);
    await tester.pump();
    await tester.tap(keyboardChip);
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'SAVE10');
    await tester.tap(find.text('Apply'));
    await tester.pump();

    expect(find.text('Total: 88.20'), findsOneWidget);
  });
}
