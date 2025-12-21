part of '../revolve.dart';

/// Configuration for a single orbital ring
class RevolveRing {
  /// Creates a revolve ring configuration
  ///
  /// [radius] determines the distance from the center.
  ///
  /// [children] are the widgets that will orbit on this ring.
  ///
  /// [duration] sets the time for one complete orbit.
  ///
  /// [direction] sets the rotation direction.
  ///
  /// [startAngle] sets the initial angle position in radians.
  ///
  /// [decoration] allows visual customization of the orbit path.
  ///
  /// [curve] sets the animation curve for the orbit.
  const RevolveRing({
    required this.radius,
    required this.children,
    this.duration = const Duration(seconds: 10),
    this.direction = RevolveDirection.clockwise,
    this.startAngle = 0,
    this.decoration,
    this.curve = Curves.linear,
  });

  /// Radius of the ring
  final double radius;

  /// Children to orbit on this ring
  final List<RevolveChild> children;

  /// Duration for one complete orbit
  final Duration duration;

  /// curve for the orbit animation
  final Curve curve;

  /// Direction of rotation
  final RevolveDirection direction;

  /// Starting angle in radians (0 is right, pi/2 is bottom, etc.)
  final double startAngle;

  /// Visual decoration for the orbit path
  final OrbitDecoration? decoration;

  RevolveRing copyWith({
    double? radius,
    List<RevolveChild>? children,
    Duration? duration,
    RevolveDirection? direction,
    double? startAngle,
    OrbitDecoration? decoration,
    Curve? curve,
  }) {
    return RevolveRing(
      radius: radius ?? this.radius,
      children: children ?? this.children,
      duration: duration ?? this.duration,
      direction: direction ?? this.direction,
      startAngle: startAngle ?? this.startAngle,
      decoration: decoration ?? this.decoration,
      curve: curve ?? this.curve,
    );
  }
}
