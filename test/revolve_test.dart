import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:revolve/revolve.dart';

void main() {
  group('Revolve Widget Tests', () {
    testWidgets('Revolve renders without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const TestApp(child: Revolve(rings: [])));

      expect(find.byType(Revolve), findsOneWidget);
      await expectLater(
        find.byType(Revolve),
        matchesGoldenFile('golden/revolve_without_crashing.png'),
      );
    });

    testWidgets('Revolve renders with center widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const TestApp(
          child: Revolve(center: Icon(Icons.star), rings: []),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      await expectLater(
        find.byType(Revolve),
        matchesGoldenFile('golden/revolve_with_center_widget.png'),
      );
    });

    testWidgets('Revolve renders single ring with children', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          child: Revolve(
            rings: [
              RevolveRing(
                radius: 100,
                children: List.generate(20, (index) {
                  return RevolveChild(
                    child: Icon(index.isEven ? Icons.favorite : Icons.star),
                    offset: (2 * math.pi / 20) * index,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsNWidgets(10));
      expect(find.byIcon(Icons.star), findsNWidgets(10));
      await expectLater(
        find.byType(Revolve),
        matchesGoldenFile('golden/revolve_single_ring_with_children.png'),
      );
    });

    testWidgets('Revolve renders multiple rings', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Revolve(
            rings: [
              RevolveRing(
                radius: 50,
                children: [const RevolveChild(child: Text('Ring 1'))],
              ),
              RevolveRing(
                radius: 100,
                children: [const RevolveChild(child: Text('Ring 2'))],
              ),
            ],
          ),
        ),
      );

      expect(find.text('Ring 1'), findsOneWidget);
      expect(find.text('Ring 2'), findsOneWidget);
      await expectLater(
        find.byType(Revolve),
        matchesGoldenFile('golden/revolve_multiple_rings.png'),
      );
    });

    testWidgets('Animation controller runs', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Revolve(
            rings: [
              RevolveRing(
                radius: 100,
                duration: const Duration(seconds: 1),
                children: [const RevolveChild(child: Icon(Icons.circle))],
              ),
            ],
          ),
        ),
      );

      // Pump initial frame
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byIcon(Icons.circle), findsOneWidget);
      await expectLater(
        find.byType(Revolve),
        matchesGoldenFile('golden/revolve_animation_running.png'),
      );
    });
  });
  testWidgets('test negative offset for children', (tester) async {
    await tester.pumpWidget(
      TestApp(
        child: Revolve(
          rings: [
            RevolveRing(
              radius: 100,
              children: List.generate(20, (index) {
                return RevolveChild(
                  child: Icon(index.isEven ? Icons.favorite : Icons.star),
                  offset: -((2 * math.pi / 20) * index),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite), findsNWidgets(10));
    expect(find.byIcon(Icons.star), findsNWidgets(10));
    await expectLater(
      find.byType(Revolve),
      matchesGoldenFile('golden/revolve_negative_offset.png'),
    );
  });
}

class TestApp extends StatelessWidget {
  final Widget? child;
  const TestApp({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Scaffold(body: child)),
    );
  }
}
