import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Wall {
  Vector2 origin;
  Vector2 direction;
  SpriteSheet spriteSheet;

  Wall({
    required this.origin,
    required this.direction,
    required this.spriteSheet,
  });

  void draw(Canvas canvas, double nearestU, int col, double offset) {
    final spriteId = (nearestU * spriteSheet.columns).toInt();
    final sprite = spriteSheet.getSpriteById(spriteId);
    sprite.render(
      canvas,
      position: Vector2(col.toDouble(), offset),
      size: Vector2(1, 600 - 2 * offset),
    );
  }
}
