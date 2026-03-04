import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Circular step counter widget with animated progress
class StepCounterCircle extends StatefulWidget {
  final int steps;
  final int goal;
  final double size;
  final bool showAnimation;

  const StepCounterCircle({
    super.key,
    required this.steps,
    required this.goal,
    this.size = 240,
    this.showAnimation = true,
  });

  @override
  State<StepCounterCircle> createState() => _StepCounterCircleState();
}

class _StepCounterCircleState extends State<StepCounterCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: 0, end: widget.steps / widget.goal).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    if (widget.showAnimation) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(StepCounterCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.steps != widget.steps || oldWidget.goal != widget.goal) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.steps / widget.goal,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGoalReached = widget.steps >= widget.goal;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _CircleProgressPainter(
              progress: _animation.value.clamp(0.0, 1.0),
              isGoalReached: isGoalReached,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Step icon
                  Icon(
                    Icons.directions_walk,
                    size: 32,
                    color: isGoalReached
                        ? AppColors.success
                        : AppColors.primary.withOpacity(0.6),
                  ),
                  const SizedBox(height: 8),
                  // Step count
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: widget.steps),
                    duration: widget.showAnimation
                        ? const Duration(milliseconds: 1500)
                        : Duration.zero,
                    builder: (context, value, child) {
                      return Text(
                        _formatNumber(value),
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: isGoalReached
                              ? AppColors.success
                              : Colors.black87,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'of ${_formatNumber(widget.goal)} steps',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress percentage
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isGoalReached
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isGoalReached
                          ? '🎉 Goal Reached!'
                          : '${((_animation.value) * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isGoalReached
                            ? AppColors.success
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final bool isGoalReached;

  _CircleProgressPainter({
    required this.progress,
    required this.isGoalReached,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: isGoalReached
            ? [AppColors.success, AppColors.success.withOpacity(0.8)]
            : [AppColors.primary, AppColors.secondary],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw dots at intervals
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final angle = (2 * math.pi * i / 8) - math.pi / 2;
      final dotCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawCircle(dotCenter, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isGoalReached != isGoalReached;
  }
}

/// Mini step counter for compact display
class MiniStepCounter extends StatelessWidget {
  final int steps;
  final int goal;

  const MiniStepCounter({
    super.key,
    required this.steps,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (steps / goal).clamp(0.0, 1.0);
    final isGoalReached = steps >= goal;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isGoalReached
            ? AppColors.success.withOpacity(0.1)
            : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mini circular progress
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(
                    isGoalReached ? AppColors.success : AppColors.primary,
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.directions_walk,
                    size: 18,
                    color: isGoalReached
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$steps',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isGoalReached ? AppColors.success : Colors.black87,
                ),
              ),
              Text(
                'of $goal steps',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
