import 'dart:math' as math;

import 'package:example/child_config.dart';
import 'package:example/curves_extension.dart';
import 'package:example/ring_config.dart';
import 'package:flutter/material.dart';
import 'package:revolve/revolve.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Revolve Interactive Demo',
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(primaryColor: Colors.red),
      themeMode: ThemeMode.dark,
      home: const RevolveDemo(),
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
    );
  }
}

class RevolveDemo extends StatefulWidget {
  const RevolveDemo({super.key});

  @override
  State<RevolveDemo> createState() => _RevolveDemoState();
}

class _RevolveDemoState extends State<RevolveDemo> {
  final List<RingConfig> _rings = [
    RingConfig(
      radius: 80,
      childrenCount: 3,
      duration: const Duration(seconds: 8),
      orbitColor: Colors.green,
      orbitStyle: OrbitStyle.dashed,
      childIcon: Icons.star,
      childColor: Colors.green,
    ),
  ];

  // Store children configurations for each ring
  final Map<int, List<ChildConfig>> _ringChildren = {
    0: [
      ChildConfig(icon: Icons.star, color: Colors.green),
      ChildConfig(icon: Icons.star, color: Colors.green),
      ChildConfig(icon: Icons.star, color: Colors.green),
    ],
  };

  int? _selectedRingIndex;

  final List<IconData> _availableIcons = [
    Icons.circle,
    Icons.star,
    Icons.favorite,
    Icons.diamond,
    Icons.square,
    Icons.hexagon,
    Icons.cloud,
    Icons.flash_on,
    Icons.auto_awesome,
    Icons.emoji_events,
    Icons.pets,
    Icons.rocket_launch,
  ];

  final List<Color> _availableColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];

  void _addRing() {
    setState(() {
      final lastRadius = _rings.isEmpty ? 60.0 : _rings.last.radius;
      final newRadius = (lastRadius + 60).clamp(50.0, 300.0);
      final ringIndex = _rings.length;
      _rings.add(
        RingConfig(
          radius: newRadius,
          childrenCount: 4,
          orbitColor: Colors.primaries[_rings.length % Colors.primaries.length],
          childColor: Colors.primaries[_rings.length % Colors.primaries.length],
        ),
      );
      // Initialize children for the new ring with random icons
      final random = math.Random();
      _ringChildren[ringIndex] = List.generate(
        4,
        (i) => ChildConfig(
          icon: _availableIcons[random.nextInt(_availableIcons.length)],
          color: Colors.primaries[ringIndex % Colors.primaries.length],
        ),
      );
      _selectedRingIndex = _rings.length - 1;
    });
  }

  void _removeRing(int index) {
    setState(() {
      _rings.removeAt(index);
      _ringChildren.remove(index);
      // Reindex remaining children
      final updatedChildren = <int, List<ChildConfig>>{};
      _ringChildren.forEach((key, value) {
        if (key > index) {
          updatedChildren[key - 1] = value;
        } else {
          updatedChildren[key] = value;
        }
      });
      _ringChildren.clear();
      _ringChildren.addAll(updatedChildren);

      if (_selectedRingIndex == index) {
        _selectedRingIndex = null;
      } else if (_selectedRingIndex != null && _selectedRingIndex! > index) {
        _selectedRingIndex = _selectedRingIndex! - 1;
      }
    });
  }

  void _addChildToRing(int ringIndex) {
    setState(() {
      final children = _ringChildren[ringIndex] ?? [];
      final random = math.Random();
      children.add(
        ChildConfig(
          icon: _availableIcons[random.nextInt(_availableIcons.length)],
          color: _availableColors[random.nextInt(_availableColors.length)],
        ),
      );
      _ringChildren[ringIndex] = children;
      _rings[ringIndex] = _rings[ringIndex].copyWith(
        childrenCount: children.length,
      );
    });
  }

  void _removeChildFromRing(int ringIndex, int childIndex) {
    setState(() {
      final children = _ringChildren[ringIndex] ?? [];
      if (children.length > 1) {
        children.removeAt(childIndex);
        _ringChildren[ringIndex] = children;
        _rings[ringIndex] = _rings[ringIndex].copyWith(
          childrenCount: children.length,
        );
      }
    });
  }

  void _updateRing(int index, RingConfig config) {
    setState(() {
      _rings[index] = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(title: const Text('Revolve Interactive Demo')),
      body: isLargeScreen ? _buildLargeScreenLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildLargeScreenLayout() {
    return Row(
      children: [
        SizedBox(width: 350, child: _buildControlPanel()),
        const VerticalDivider(width: 1),
        Expanded(child: _buildPreview()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(flex: 2, child: _buildPreview()),
        const Divider(height: 1),
        Expanded(flex: 3, child: _buildControlPanel()),
      ],
    );
  }

  Widget _buildPreview() {
    return Center(
      child: _rings.isEmpty
          ? const Text(
              'Add a ring to get started',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final maxRadius = _rings.isEmpty
                    ? 100.0
                    : _rings.map((r) => r.radius).reduce(math.max);
                final size = math.min(
                  math.min(constraints.maxWidth, constraints.maxHeight),
                  (maxRadius + 50) * 2,
                );

                return SizedBox(
                  width: size,
                  height: size,
                  child: Revolve(
                    center: _buildCenterWidget(),
                    rings: _rings
                        .asMap()
                        .entries
                        .map((entry) => _buildRing(entry.key, entry.value))
                        .toList(),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildControlPanel() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Rings (${_rings.length})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: _addRing,
              tooltip: 'Add Ring',
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_rings.isEmpty)
          Center(
            child: ElevatedButton.icon(
              onPressed: _addRing,
              icon: const Icon(Icons.add),
              label: const Text('Add First Ring'),
            ),
          )
        else
          ..._rings.asMap().entries.map((entry) {
            final index = entry.key;
            final ring = entry.value;
            final isSelected = _selectedRingIndex == index;

            return Card(
              color: isSelected ? Colors.grey.shade900 : null,
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ring.childColor,
                      child: Icon(
                        ring.childIcon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text('Ring ${index + 1}'),
                    subtitle: Text(
                      'Radius: ${ring.radius.toInt()} • Children: ${ring.childrenCount}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isSelected
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedRingIndex = isSelected ? null : index;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeRing(index),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildRingControls(index, ring),
                    ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildRingControls(int index, RingConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Radius
        Text('Radius: ${config.radius.toInt()}'),
        Slider(
          value: config.radius,
          min: 50,
          max: 300,
          divisions: 50,
          onChanged: (value) {
            _updateRing(index, config.copyWith(radius: value));
          },
        ),
        const SizedBox(height: 8),

        // Children Management
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Children (${config.childrenCount})',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ElevatedButton.icon(
              onPressed: () => _addChildToRing(index),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...(_ringChildren[index] ?? []).asMap().entries.map((entry) {
          final childIndex = entry.key;
          final child = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: child.color,
                child: Icon(child.icon, color: Colors.white, size: 16),
              ),
              title: Text(
                'Child ${childIndex + 1}',
                style: const TextStyle(fontSize: 14),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, size: 18),
                onPressed: () => _removeChildFromRing(index, childIndex),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),

        // Duration
        Text('Duration: ${config.duration.inSeconds}s'),
        Slider(
          value: config.duration.inSeconds.toDouble(),
          min: 1,
          max: 60,
          divisions: 59,
          onChanged: (value) {
            _updateRing(
              index,
              config.copyWith(duration: Duration(seconds: value.toInt())),
            );
          },
        ),
        const SizedBox(height: 8),

        // Direction
        Row(
          children: [
            const Text('Direction: '),
            const SizedBox(width: 8),
            SegmentedButton<RevolveDirection>(
              segments: const [
                ButtonSegment(
                  value: RevolveDirection.clockwise,
                  label: Text('CW'),
                  icon: Icon(Icons.rotate_right),
                ),
                ButtonSegment(
                  value: RevolveDirection.counterClockwise,
                  label: Text('CCW'),
                  icon: Icon(Icons.rotate_left),
                ),
              ],
              selected: {config.direction},
              onSelectionChanged: (Set<RevolveDirection> selection) {
                _updateRing(index, config.copyWith(direction: selection.first));
              },
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Curve
        DropdownButtonFormField<Curve>(
          initialValue: config.curve,
          decoration: const InputDecoration(
            labelText: 'Animation Curve',
            border: OutlineInputBorder(),
          ),
          items: CurvesExtension.values.map((curve) {
            return DropdownMenuItem(
              value: curve,
              child: Text(
                CurvesExtension.names[CurvesExtension.values.indexOf(curve)],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              _updateRing(index, config.copyWith(curve: value));
            }
          },
        ),
        const SizedBox(height: 16),

        // Orbit Style
        DropdownButtonFormField<OrbitStyle>(
          initialValue: config.orbitStyle,
          decoration: const InputDecoration(
            labelText: 'Orbit Style',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: OrbitStyle.solid, child: Text('Solid')),
            DropdownMenuItem(value: OrbitStyle.dashed, child: Text('Dashed')),
            DropdownMenuItem(value: OrbitStyle.dotted, child: Text('Dotted')),
            DropdownMenuItem(value: OrbitStyle.none, child: Text('None')),
          ],
          onChanged: (value) {
            if (value != null) {
              _updateRing(index, config.copyWith(orbitStyle: value));
            }
          },
        ),
        const SizedBox(height: 8),

        // Orbit Width
        Text('Orbit Width: ${config.orbitWidth.toStringAsFixed(1)}'),
        Slider(
          value: config.orbitWidth,
          min: 0.5,
          max: 5,
          divisions: 9,
          onChanged: (value) {
            _updateRing(index, config.copyWith(orbitWidth: value));
          },
        ),
        const SizedBox(height: 8),

        // Orbit Opacity
        Text('Orbit Opacity: ${(config.orbitOpacity * 100).toInt()}%'),
        Slider(
          value: config.orbitOpacity,
          min: 0,
          max: 1,
          divisions: 10,
          onChanged: (value) {
            _updateRing(index, config.copyWith(orbitOpacity: value));
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  RevolveRing _buildRing(int index, RingConfig config) {
    final children = _ringChildren[index] ?? [];
    return RevolveRing(
      radius: config.radius,
      duration: config.duration,
      direction: config.direction,
      curve: config.curve,
      decoration: OrbitDecoration(
        color: config.orbitColor,
        style: config.orbitStyle,
        width: config.orbitWidth,
        opacity: config.orbitOpacity,
      ),
      children: children.asMap().entries.map((entry) {
        final childIndex = entry.key;
        final child = entry.value;
        return RevolveChild(
          offset: (2 * math.pi / children.length) * childIndex,
          child: _buildOrbitIcon(child.icon, child.color, childIndex),
        );
      }).toList(),
    );
  }

  Widget _buildCenterWidget() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.blue.shade300, Colors.purple.shade600],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.5),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: const Icon(
        Icons.center_focus_strong,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildOrbitIcon(IconData icon, Color color, int number) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.9),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.6),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(child: Icon(icon, color: Colors.white, size: 20)),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${number + 1}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
