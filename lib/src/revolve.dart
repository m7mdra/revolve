part of '../revolve.dart';

/// Main widget that contains multiple orbital rings
class Revolve extends StatelessWidget {
  ///
  /// [rings] List of rings to display
  /// [center] Optional center widget
  const Revolve({super.key, required this.rings, this.center});

  /// List of rings to display
  final List<RevolveRing> rings;

  /// Optional center widget
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              ...rings.map((ring) => _RevolveRingWidget(ring: ring)),
              if (center != null) center!,
            ],
          ),
        );
      },
    );
  }
}
