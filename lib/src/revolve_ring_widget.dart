part of '../revolve.dart';

/// Internal widget that renders a single ring
class _RevolveRingWidget extends StatefulWidget {
  const _RevolveRingWidget({required this.ring});

  final RevolveRing ring;

  @override
  State<_RevolveRingWidget> createState() => _RevolveRingWidgetState();
}

class _RevolveRingWidgetState extends State<_RevolveRingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curvedAnimation;

  RevolveRing get _ring => widget.ring;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.ring.duration,
    )..repeat();

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.ring.curve,
    );
  }

  @override
  void didUpdateWidget(_RevolveRingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    log('Updating RevolveRingWidget');
    final oldRing = oldWidget.ring;

    if (oldRing.duration != _ring.duration) {
      log('Updating duration from ${oldRing.duration} to ${_ring.duration}');
      _controller.duration = _ring.duration;
      _controller.reset();
      _controller.repeat();
    }
    if (oldRing.curve != _ring.curve) {
      log('Updating curve from ${oldRing.curve} to ${_ring.curve}');
      _curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: _ring.curve,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curvedAnimation,
      builder: (context, child) {
        final rotationMultiplier = _ring.direction == RevolveDirection.clockwise
            ? 1.0
            : -1.0;
        final baseRotation =
            _curvedAnimation.value * 2 * math.pi * rotationMultiplier;

        return LayoutBuilder(
          builder: (context, constraints) {
            final size = math.min(constraints.maxWidth, constraints.maxHeight);

            return Stack(
              clipBehavior: Clip.none,
              children: [

                  CustomPaint(
                    size: Size(size, size),
                    painter: _OrbitPathPainter(
                      radius: _ring.radius,
                      decoration: _ring.decoration,
                    ),
                  ),
                ..._ring.children.asMap().entries.map((entry) {
                  final revolveChild = entry.value;

                  final angle =
                      _ring.startAngle + revolveChild.offset + baseRotation;

                  final x = size / 2 + _ring.radius * math.cos(angle);
                  final y = size / 2 + _ring.radius * math.sin(angle);

                  return Positioned(
                    left: x,
                    top: y,
                    child: FractionalTranslation(
                      translation: const Offset(-0.5, -0.5),
                      child: revolveChild.child,
                    ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RevolveRing>('ring', widget.ring));
  }

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) {
    return DiagnosticsProperty(
      name ?? 'RevolveRingWidget',
      widget.ring,
      style: style ?? DiagnosticsTreeStyle.singleLine,
    );
  }
}
