# Revolve

A Flutter package for creating beautiful orbital animations with multiple rings and children that revolve indefinitely around a center point.

[![pub package](https://img.shields.io/pub/v/revolve.svg)](https://pub.dev/packages/revolve)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)



https://github.com/user-attachments/assets/9fd08f69-d28f-4b44-93e8-51a052c9a039





#### Web demo is available [here](https://elaborate-praline-37948f.netlify.app/)


## Getting started

Add `revolve` to your `pubspec.yaml`:

```yaml
dependencies:
  revolve: ^0.0.1
```

Then import the package:

```dart
import 'package:revolve/revolve.dart';
```

## Usage

Create a `Revolve` widget with multiple rings:

```dart
Revolve(
  center: Icon(Icons.star, size: 40),
  rings: [
    // Inner ring - fast rotation with dashed orbit
    RevolveRing(
      radius: 80,
      duration: const Duration(seconds: 10),
      direction: RevolveDirection.clockwise,
      decoration: const OrbitDecoration(
        color: Colors.blue,
        width: 2.0,
        style: OrbitStyle.dashed,
        opacity: 0.6,
      ),
      children: [
        RevolveChild(
          child: Icon(Icons.favorite, color: Colors.red),
        ),
        RevolveChild(
          offset: math.pi, // Position on opposite side
          child: Icon(Icons.favorite, color: Colors.pink),
        ),
      ],
    ),
```

## Example

Check out the [example](example/) folder for a complete demo with multiple rings, different speeds, and custom widgets.

## Additional information

Contributions are welcome! Please file issues and pull requests on the [GitHub repository](https://github.com/m7mdra/revolve).

