import 'package:flutter_test/flutter_test.dart';
import 'package:model_trainig/services/classifier.dart';

void main() {
  test('parses standard label lines', () {
    expect(parseLabels('0 Mug\n1 Bottle\n'), ['Mug', 'Bottle']);
  });

  test('parses Windows line endings, trailing blank line, and multi-word labels', () {
    expect(
      parseLabels('0 cat\r\n1 hiding person\r\n2 Car keys\r\n\r\n'),
      ['cat', 'hiding person', 'Car keys'],
    );
  });
}
