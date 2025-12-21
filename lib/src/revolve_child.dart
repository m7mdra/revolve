part of '../revolve.dart';

/// Configuration for a child widget on a ring
class RevolveChild {
  /// Creates a revolve child configuration
  const RevolveChild({required this.child, this.offset = 0});

  /// The widget to display
  final Widget child;

  /// Offset angle in radians from the starting position
  final double offset;
}
