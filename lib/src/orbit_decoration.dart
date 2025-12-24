part of '../revolve.dart';

/// Decoration configuration for the orbit path
class OrbitDecoration {
  /// Creates an orbit decoration configuration
  const OrbitDecoration({
    this.color = Colors.grey,
    this.width = 1.0,
    this.style = OrbitStyle.solid,
    this.dashPattern,
    this.opacity = 1.0,
  });

  /// Color of the orbit line. defaults to grey.
  final Color color;

  /// Width of the orbit line
  final double width;

  /// Style of the orbit line (solid, dashed, dotted, or none)
  final OrbitStyle style;

  /// Custom dash pattern for dashed style.
  /// Example: [5, 3] creates 5px dash, 3px gap pattern
  /// If null, uses default pattern based on style
  final List<double>? dashPattern;

  /// Opacity of the orbit line (0.0 to 1.0)
  final double opacity;

  /// Gets the effective dash pattern based on style
  List<double> get effectiveDashPattern {
    if (dashPattern != null) return dashPattern!;

    switch (style) {
      case OrbitStyle.dashed:
        return [8, 4];
      case OrbitStyle.dotted:
        return [2, 3];
      case OrbitStyle.solid:
      case OrbitStyle.none:
        return [];
    }
  }
}
