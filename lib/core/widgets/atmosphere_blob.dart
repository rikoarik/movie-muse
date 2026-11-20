import 'package:flutter/material.dart';

class AtmosphereBlob extends StatelessWidget {
  const AtmosphereBlob({
    required this.size,
    required this.color,
    this.alpha = 0.45,
    super.key,
  });

  final double size;
  final Color color;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: alpha * 0.42),
              color.withValues(alpha: 0),
            ],
            stops: const [0.0, 0.58, 1.0],
          ),
        ),
      ),
    );
  }
}
