import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nagardrishti/screens/citizen/map_screen.dart';
import 'package:nagardrishti/services/project_provider.dart';
import 'package:nagardrishti/services/geofence_service.dart';
import 'package:nagardrishti/theme.dart';

Widget _wrap() => MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ProjectProvider()),
    ChangeNotifierProvider(create: (_) => GeofenceService()),
  ],
  child: MaterialApp(
    theme: AppTheme.lightTheme,
    home: const CitizenMapScreen(),
  ),
);

void main() {
  group('CitizenMapScreen', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      // Map screen should mount without throwing
      expect(find.byType(CitizenMapScreen), findsOneWidget);
    });

    testWidgets('search bar is present', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.byType(TextField), findsAtLeastNWidgets(1));
    });

    testWidgets('filter chips render', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      // "All" filter chip should exist
      expect(find.text('All'), findsAtLeastNWidgets(1));
    });

    testWidgets('draggable sheet shows project count', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      // Project count text should appear (e.g., "3 Projects")
      expect(find.textContaining('Projects'), findsAtLeastNWidgets(1));
    });
  });
}
