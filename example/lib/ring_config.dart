import 'package:flutter/material.dart';
import 'package:revolve/revolve.dart';

class RingConfig {
  double radius;
  int childrenCount;
  Duration duration;
  RevolveDirection direction;
  Curve curve;
  Color orbitColor;
  OrbitStyle orbitStyle;
  double orbitWidth;
  double orbitOpacity;
  IconData childIcon;
  Color childColor;

  RingConfig({
    this.radius = 100,
    this.childrenCount = 4,
    this.duration = const Duration(seconds: 10),
    this.direction = RevolveDirection.clockwise,
    this.curve = Curves.linear,
    this.orbitColor = Colors.blue,
    this.orbitStyle = OrbitStyle.solid,
    this.orbitWidth = 1.5,
    this.orbitOpacity = 0.6,
    this.childIcon = Icons.circle,
    this.childColor = Colors.blue,
  });

  RingConfig copyWith({
    double? radius,
    int? childrenCount,
    Duration? duration,
    RevolveDirection? direction,
    Curve? curve,
    Color? orbitColor,
    OrbitStyle? orbitStyle,
    double? orbitWidth,
    double? orbitOpacity,
    IconData? childIcon,
    Color? childColor,
  }) {
    return RingConfig(
      radius: radius ?? this.radius,
      childrenCount: childrenCount ?? this.childrenCount,
      duration: duration ?? this.duration,
      direction: direction ?? this.direction,
      curve: curve ?? this.curve,
      orbitColor: orbitColor ?? this.orbitColor,
      orbitStyle: orbitStyle ?? this.orbitStyle,
      orbitWidth: orbitWidth ?? this.orbitWidth,
      orbitOpacity: orbitOpacity ?? this.orbitOpacity,
      childIcon: childIcon ?? this.childIcon,
      childColor: childColor ?? this.childColor,
    );
  }
}
