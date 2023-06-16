import 'dart:math';

import 'package:flutter/material.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/features/graph_view/point.dart';

class AnimatedCanvas extends StatefulWidget {
  List<CardIndex> cards;
  AnimatedCanvas({Key? key, required this.cards}) : super(key: key);

  @override
  _AnimatedCanvasState createState() => _AnimatedCanvasState();
}

class _AnimatedCanvasState extends State<AnimatedCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<CardPoint> _points;
  CardPoint? _focusedPoint;

  final double _velocity = 0.3;
  final double _basePointSize = 0.5;
  final Color _circleColor = Colors.white;

  _AnimatedCanvasState() {
    _points = []; // Initialize _points list here
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 16),
      vsync: this,
    )..addListener(() {
        setState(() {
          _updateScene();
        });
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initScene();
      _animationController.repeat();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initScene() {
    _points = [];
    final random = Random();
    for (var i = 0; i < widget.cards.length; i++) {
      _points.add(CardPoint(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: (_basePointSize + random.nextInt(3) + 5).toDouble(),
        vx: _getRandomVelocity(),
        vy: _getRandomVelocity(),
        cardIndex: widget.cards[i],
      ));
    }
  }

  void _updateScene() {
    for (var i = 0; i < widget.cards.length; i++) {
      _points[i].animate();
    }
  }

  double _getRandomVelocity() {
    return _velocity - (Random().nextDouble() * 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        _setFocusedPoint(localPosition.dx / renderBox.size.width,
            localPosition.dy / renderBox.size.height);
      },
      child: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.black,
        child: CustomPaint(
          painter: _CanvasPainter(_points, _circleColor, _focusedPoint),
        ),
      ),
    );
  }

  void _setFocusedPoint(double x, double y) {
    CardPoint? newFocusedPoint;
    bool shouldShowDialog = false;

    for (final point in _points) {
      // ? I originally thought that using the condition (point.x - x).abs() <= point.radius would be sufficient. However, after testing it, I found that the units of coordinates and distance do not match. After repeated testing, I found that modifying it to (point.x - x).abs() * 100 <= point.radius is closer to the actual requirements.
      if ((point.x - x).abs() * 100 <= point.radius &&
          (point.y - y).abs() * 100 <= point.radius) {
        if (_focusedPoint == point) {
          shouldShowDialog = true;
        } else {
          newFocusedPoint = point;
          final xOffset = 0.5 - newFocusedPoint.x;
          final yOffset = 0.5 - newFocusedPoint.y;

          for (final point in _points) {
            point.x += xOffset;
            point.y += yOffset;
          }
        }
        break;
      }
    }

    // void _addPoint(double x, double y) {
    //   setState(() {
    //     _points.add(CardPoint(
    //       x: x,
    //       y: y,
    //       radius: _basePointSize + Random().nextInt(3) + 5,
    //       vx: _getRandomVelocity(),
    //       vy: _getRandomVelocity(),
    //     ));
    //   });
    // }

    setState(() {
      if (shouldShowDialog) {
        // Clicked on the focused point, show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Point Clicked'),
              content: const Text('You clicked the focused point.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (newFocusedPoint != null) {
        // Clicked on an unfocused point, update the focus
        _focusedPoint = newFocusedPoint;
      }
    });
  }
}

class _CanvasPainter extends CustomPainter {
  final List<CardPoint> points;
  final Color circleColor;
  final CardPoint? focusedPoint;

  _CanvasPainter(this.points, this.circleColor, this.focusedPoint);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final isFocused = point == focusedPoint;

      final center = Offset(point.x * size.width, point.y * size.height);
      final radius = point.radius;

      final clickableRect = Rect.fromCircle(center: center, radius: radius);
      final clickablePath = Path()..addOval(clickableRect);

      _drawPoint(canvas, point, size, isFocused);

      canvas.drawPath(clickablePath, Paint()..color = Colors.transparent);
    }

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      for (var j = i; j < points.length; j++) {
        final otherPoint = points[j];
        _drawLine(canvas, point, otherPoint, size);
      }
    }
  }

  void _drawPoint(Canvas canvas, CardPoint point, Size size, bool isFocused) {
    final center = Offset(point.x * size.width, point.y * size.height);
    final paint = Paint()..color = isFocused ? Colors.red : circleColor;

    canvas.drawCircle(center, point.radius, paint);
  }

  void _drawLine(Canvas canvas, CardPoint point1, CardPoint point2, Size size) {
    final t1 = 80 * (point1.radius / 2);
    final t2 = 80 * (point2.radius / 2);

    final threshold = t1 > t2 ? t1 : t2;

    final distance =
        sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2));
    if (distance < threshold) {
      final opacity = 1 - distance / threshold * 1.2;
      final paint = Paint()
        ..color = circleColor.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;

      final startPoint = Offset(point1.x * size.width, point1.y * size.height);
      final endPoint = Offset(point2.x * size.width, point2.y * size.height);

      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(_CanvasPainter oldDelegate) {
    return true;
  }
}
