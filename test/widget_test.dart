import 'package:flutter_test/flutter_test.dart';
import 'package:reelora/app/app.dart';
import 'package:reelora/app/di/injection.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  testWidgets('renders HomeView with greeting content', (tester) async {
    await tester.pumpWidget(const ReeloraApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Reelora'), findsOneWidget);
    expect(find.text('Refresh'), findsOneWidget);
  });
}
