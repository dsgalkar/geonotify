import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nagardrishti/models/project.dart';
import 'package:nagardrishti/widgets/project_card.dart';
import 'package:nagardrishti/theme.dart';

final _testProject = CivicProject(
  id: '1',
  title: 'AIIMS Pune Phase 2',
  category: 'hospital',
  description: 'Test description',
  status: 'Under Construction',
  latitude: 18.5204,
  longitude: 73.8567,
  budget: 4200,
  spent: 2730,
  completionPercent: 65,
  startDate: 'Jan 2023',
  expectedEndDate: 'Dec 2025',
  department: 'Ministry of Health',
  contractor: 'L&T Construction',
  createdAt: DateTime(2023, 1, 1),
);

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  home: Scaffold(body: child),
);

void main() {
  group('ProjectCard — full card', () {
    testWidgets('renders project title', (tester) async {
      await tester.pumpWidget(_wrap(ProjectCard(
        project: _testProject,
        onTap: () {},
        compact: false,
      )));
      expect(find.text('AIIMS Pune Phase 2'), findsOneWidget);
    });

    testWidgets('renders status badge', (tester) async {
      await tester.pumpWidget(_wrap(ProjectCard(
        project: _testProject,
        onTap: () {},
        compact: false,
      )));
      expect(find.text('Under Construction'), findsOneWidget);
    });

    testWidgets('tapping calls onTap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(_wrap(ProjectCard(
        project: _testProject,
        onTap: () => tapped = true,
        compact: false,
      )));
      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, isTrue);
    });
  });

  group('ProjectCard — compact card', () {
    testWidgets('renders in compact mode', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        width: 220,
        child: ProjectCard(
          project: _testProject,
          onTap: () {},
          compact: true,
        ),
      )));
      expect(find.text('AIIMS Pune Phase 2'), findsOneWidget);
      expect(find.text('65%'), findsOneWidget);
    });
  });
}
