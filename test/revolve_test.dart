import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:revolve/revolve.dart';


import 'dart:math' as math;


void main() {
  group('Revolve Widget Tests', () {
    testWidgets('Revolve renders without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Revolve(rings: [])),
        ),
      );

      expect(find.byType(Revolve), findsOneWidget);
    });

    testWidgets('Revolve renders with center widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Revolve(center: Icon(Icons.star), rings: []),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('Revolve renders single ring with children', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Revolve(
              rings: [
                RevolveRing(
                  radius: 100,
                  children: [
                    const RevolveChild(child: Icon(Icons.favorite)),
                    RevolveChild(
                      offset: math.pi,
                      child: const Icon(Icons.star),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('Revolve renders multiple rings', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Revolve(
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
        ),
      );

      expect(find.text('Ring 1'), findsOneWidget);
      expect(find.text('Ring 2'), findsOneWidget);
    });

    testWidgets('Animation controller runs', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Revolve(
              rings: [
                RevolveRing(
                  radius: 100,
                  duration: const Duration(seconds: 1),
                  children: [const RevolveChild(child: Icon(Icons.circle))],
                ),
              ],
            ),
          ),
        ),
      );

      // Pump initial frame
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byIcon(Icons.circle), findsOneWidget);
    });
  });

  group('RevolveRing Configuration', () {
    test('RevolveRing has correct default values', () {
      final ring = RevolveRing(radius: 100, children: []);

      expect(ring.radius, 100);
      expect(ring.duration, const Duration(seconds: 10));
      expect(ring.direction, RevolveDirection.clockwise);
      expect(ring.startAngle, 0);
    });

    test('RevolveRing accepts custom values', () {
      final ring = RevolveRing(
        radius: 200,
        duration: const Duration(seconds: 5),
        direction: RevolveDirection.counterClockwise,
        startAngle: math.pi / 2,
        children: [],
      );

      expect(ring.radius, 200);
      expect(ring.duration, const Duration(seconds: 5));
      expect(ring.direction, RevolveDirection.counterClockwise);
      expect(ring.startAngle, math.pi / 2);
    });

    test('RevolveRing accepts orbit decoration', () {
      const decoration = OrbitDecoration(
        color: Colors.blue,
        width: 2.0,
        style: OrbitStyle.dashed,
        opacity: 0.5,
      );

      final ring = RevolveRing(
        radius: 100,
        decoration: decoration,
        children: [],
      );

      expect(ring.decoration, decoration);
      expect(ring.decoration?.color, Colors.blue);
      expect(ring.decoration?.width, 2.0);
      expect(ring.decoration?.style, OrbitStyle.dashed);
      expect(ring.decoration?.opacity, 0.5);
    });
  });

  group('OrbitDecoration Configuration', () {
    test('OrbitDecoration has correct default values', () {
      const decoration = OrbitDecoration(color: Colors.red);

      expect(decoration.color, Colors.red);
      expect(decoration.width, 1.0);
      expect(decoration.style, OrbitStyle.solid);
      expect(decoration.opacity, 1.0);
      expect(decoration.dashPattern, null);
    });

    test('OrbitDecoration effective dash pattern for dashed style', () {
      const decoration = OrbitDecoration(
        color: Colors.blue,
        style: OrbitStyle.dashed,
      );

      expect(decoration.effectiveDashPattern, [8, 4]);
    });

    test('OrbitDecoration effective dash pattern for dotted style', () {
      const decoration = OrbitDecoration(
        color: Colors.blue,
        style: OrbitStyle.dotted,
      );

      expect(decoration.effectiveDashPattern, [2, 3]);
    });

    test('OrbitDecoration custom dash pattern', () {
      const decoration = OrbitDecoration(
        color: Colors.blue,
        style: OrbitStyle.dashed,
        dashPattern: [5, 3, 2, 3],
      );

      expect(decoration.effectiveDashPattern, [5, 3, 2, 3]);
    });
  });

  group('RevolveChild Configuration', () {
    test('RevolveChild has correct default values', () {
      const child = RevolveChild(child: SizedBox());

      expect(child.offset, 0);
    });

    test('RevolveChild accepts custom offset', () {
      const child = RevolveChild(offset: math.pi, child: SizedBox());

      expect(child.offset, math.pi);
    });
  });
}
