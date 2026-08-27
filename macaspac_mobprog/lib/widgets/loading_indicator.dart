import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // kept for compatibility if you still use it somewhere
    return const CircularProgressIndicator(strokeWidth: 3);
  }
}

/// ✅ Enhancement 2: your own loading animation (3 bouncing dots)
class BouncingDotsLoading extends StatefulWidget {
  final double dotSize;
  final Color color;

  const BouncingDotsLoading({
    super.key,
    this.dotSize = 10,
    this.color = Colors.white,
  });

  @override
  State<BouncingDotsLoading> createState() => _BouncingDotsLoadingState();
}

class _BouncingDotsLoadingState extends State<BouncingDotsLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _dotOffset(double t, double delay) {
    // t = 0..1
    final x = (t + delay) % 1.0;
    // Smooth up/down bounce (0..1..0)
    final bounce = (1 - (2 * (x - 0.5)).abs());
    return bounce * 10; // height
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(0, -_dotOffset(t, 0.0)),
              child: _dot(),
            ),
            const SizedBox(width: 8),
            Transform.translate(
              offset: Offset(0, -_dotOffset(t, 0.15)),
              child: _dot(),
            ),
            const SizedBox(width: 8),
            Transform.translate(
              offset: Offset(0, -_dotOffset(t, 0.30)),
              child: _dot(),
            ),
          ],
        );
      },
    );
  }

  Widget _dot() {
    return Container(
      width: widget.dotSize,
      height: widget.dotSize,
      decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
    );
  }
}
