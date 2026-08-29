import 'package:flutter_test/flutter_test.dart';

import 'package:lova_events/main.dart';

void main() {
  testWidgets('Lova Events home screen renders with online Supabase setup', (WidgetTester tester) async {
    await tester.pumpWidget(const LovaEventsApp());

    expect(find.text('Lova Events'), findsWidgets);
    expect(find.textContaining('Supabase en ligne'), findsOneWidget);
  });
}
