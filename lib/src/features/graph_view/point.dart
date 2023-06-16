import 'package:langdida_ui/src/api_models/card.dart';

class CardPoint {
  double x;
  double y;
  final double radius;
  final double vx;
  final double vy;
  final CardIndex cardIndex;

  CardPoint({
    required this.x,
    required this.y,
    required this.radius,
    required this.vx,
    required this.vy,
    required this.cardIndex,
  });

  void animate() {
    if (y < radius || y > (1 - radius)) {
      _reverseVelocity(vy);
    } else if (x < radius || x > (1 - radius)) {
      _reverseVelocity(vx);
    }
  }

  void _reverseVelocity(double velocity) {
    velocity = -1 * velocity;
  }
}