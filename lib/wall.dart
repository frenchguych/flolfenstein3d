import 'dart:ui';

import 'package:flame/components.dart';

class Wall {
  Vector2 origin;
  Vector2 direction;
  Sprite sprite;
  final double width;
  final double height;

  Wall({
    required this.origin,
    required this.direction,
    required this.sprite,
  })  : width = sprite.srcSize.x,
        height = sprite.srcSize.y;

  void draw(Canvas canvas, double nearestU, int col, double offset) {
    final srcSize = sprite.srcSize;
    sprite.srcSize = Vector2(1, height);
    sprite.srcPosition = Vector2(nearestU * width, 0);
    sprite.render(
      canvas,
      position: Vector2(col * 1.0, offset),
      size: Vector2(1, 600 - 2 * offset),
    );
    sprite.srcSize = srcSize;
  }
}
