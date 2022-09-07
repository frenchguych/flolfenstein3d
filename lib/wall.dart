import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Walls {
  static List<Wall> all(Image image) {
    return Walls.fromNSEW(
      north: image,
      south: image,
      east: image,
      west: image,
    );
  }

  static List<Wall> fromNSEW({
    Image? north,
    Image? south,
    Image? east,
    Image? west,
  }) {
    return [
      if (west != null)
        Wall(
          origin: Vector2(0, 0),
          direction: Vector2(0, 1),
          spriteSheet: SpriteSheet(image: west, srcSize: Vector2(1, 64)),
        ),
      if (south != null)
        Wall(
          origin: Vector2(0, 1),
          direction: Vector2(1, 0),
          spriteSheet: SpriteSheet(image: south, srcSize: Vector2(1, 64)),
        ),
      if (east != null)
        Wall(
          origin: Vector2(1, 1),
          direction: Vector2(0, -1),
          spriteSheet: SpriteSheet(image: east, srcSize: Vector2(1, 64)),
        ),
      if (north != null)
        Wall(
          origin: Vector2(1, 0),
          direction: Vector2(-1, 0),
          spriteSheet: SpriteSheet(image: north, srcSize: Vector2(1, 64)),
        ),
    ];
  }
}

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
    final spriteId = (nearestU * 63).round();
    final sprite = spriteSheet.getSpriteById(spriteId);
    sprite.render(
      canvas,
      position: Vector2(col.toDouble(), offset),
      size: Vector2(1, 600 - 2 * offset),
    );
  }
}
