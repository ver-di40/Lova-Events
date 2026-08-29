import 'package:flutter_test/flutter_test.dart';

import 'package:lova_events/main.dart';

void main() {
  testWidgets('app redirects unauthenticated users to the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LovaEventsApp());

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Vous devez être connecté pour accéder à cette page.'), findsOneWidget);
  });
}
