import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Walls {
  Wall? north;
  Wall? south;
  Wall? east;
  Wall? west;

  Walls._();

  static Walls all(Image texture) {
    return Walls.fromNSEW(
      northTexture: texture,
      southTexture: texture,
      eastTexture: texture,
      westTexture: texture,
    );
  }

  static Walls fromNSEW({
    Image? northTexture,
    Image? southTexture,
    Image? eastTexture,
    Image? westTexture,
  }) {
    final walls = Walls._();

    if (westTexture != null) {
      walls.west = Wall(
        origin: Vector2(0, 0),
        direction: Vector2(0, 1),
        spriteSheet: SpriteSheet(image: westTexture, srcSize: Vector2(1, 64)),
      );
    }

    if (southTexture != null) {
      walls.south = Wall(
        origin: Vector2(0, 1),
        direction: Vector2(1, 0),
        spriteSheet: SpriteSheet(image: southTexture, srcSize: Vector2(1, 64)),
      );
    }

    if (eastTexture != null) {
      walls.east = Wall(
        origin: Vector2(1, 1),
        direction: Vector2(0, -1),
        spriteSheet: SpriteSheet(image: eastTexture, srcSize: Vector2(1, 64)),
      );
    }

    if (northTexture != null) {
      walls.north = Wall(
        origin: Vector2(1, 0),
        direction: Vector2(-1, 0),
        spriteSheet: SpriteSheet(image: northTexture, srcSize: Vector2(1, 64)),
      );
    }

    return walls;
  }

  toList() {
    return [
      if (north != null) north,
      if (south != null) south,
      if (east != null) east,
      if (west != null) west
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
