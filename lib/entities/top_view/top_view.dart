import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flolfenstein3d/entities/top_view/behaviors/behaviors.dart';
import 'package:flutter/material.dart';

import '../../flolfenstein_3d_game.dart';

class TopView extends Entity with HasGameRef<Flolfenstein3DGame> {
  TopView() : super(behaviors: [MovementBehavior()]);

  var walls = <Wall>[];

  @override
  Future<void>? onLoad() async {
    final imagesLoader = Images();
    final ubuntuMate = Sprite(
      await imagesLoader.load('ubuntu_mate.png'),
    );
    final ubuntuMateHalf = Sprite(
      await imagesLoader.load('ubuntu_mate_half.png'),
    );
    final size = gameRef.size;
    walls = [
      Wall(
        origin: Vector2(100, 100),
        direction: Vector2(100, 0),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(200, 100),
        direction: Vector2(0, 100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(200, 300),
        direction: Vector2(0, 100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(200, 400),
        direction: Vector2(100, 0),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(300, 400),
        direction: Vector2(50, 0),
        sprite: ubuntuMateHalf,
      ),
      Wall(
        origin: Vector2(450, 400),
        direction: Vector2(50, 0),
        sprite: ubuntuMateHalf,
      ),
      Wall(
        origin: Vector2(500, 400),
        direction: Vector2(100, 0),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(600, 400),
        direction: Vector2(0, -100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(600, 200),
        direction: Vector2(0, -100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(600, 100),
        direction: Vector2(100, 0),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(700, 100),
        direction: Vector2(0, 100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(700, 200),
        direction: Vector2(0, 100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(700, 300),
        direction: Vector2(0, 100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(700, 400),
        direction: Vector2(0, 100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(700, 500),
        direction: Vector2(-100, 0),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(600, 500),
        direction: Vector2(-100, 0),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(500, 500),
        direction: Vector2(-100, 0),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(400, 500),
        direction: Vector2(-100, 0),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(300, 500),
        direction: Vector2(-100, 0),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(200, 500),
        direction: Vector2(-100, 0),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(100, 500),
        direction: Vector2(0, -100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(100, 400),
        direction: Vector2(0, -100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(100, 300),
        direction: Vector2(0, -100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(100, 200),
        direction: Vector2(0, -100),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(200, 100),
        direction: Vector2(100, 0),
        sprite: ubuntuMate,
      ),
      Wall(
        origin: Vector2(300, 100),
        direction: Vector2(50, 0),
        sprite: ubuntuMateHalf,
      ),
      Wall(
        origin: Vector2(450, 100),
        direction: Vector2(50, 0),
        sprite: ubuntuMateHalf,
      ),
      Wall(
        origin: Vector2(500, 100),
        direction: Vector2(100, 0),
        sprite: ubuntuMate,
      ),
      // ----------------------------------------
      ...List.generate(
        8,
        (index) => Wall(
          origin: Vector2(100.0 * index, 0),
          direction: Vector2(100, 0),
          sprite: ubuntuMate,
        ),
      ),
      // ----------------------------------------
      ...List.generate(
        6,
        (index) => Wall(
          origin: Vector2(gameRef.size.x, 100.0 * index),
          direction: Vector2(0, 100),
          sprite: ubuntuMate,
        ),
      ),
      // ----------------------------------------
      ...List.generate(
        6,
        (index) => Wall(
          origin: Vector2(0, 100.0 * index),
          direction: Vector2(0, 100),
          sprite: ubuntuMate,
        ),
      ),
      // ----------------------------------------
      ...List.generate(
        8,
        (index) => Wall(
          origin: Vector2(100.0 * index, size.y),
          direction: Vector2(100, 0),
          sprite: ubuntuMate,
        ),
      ),
    ];
  }

  @override
  void render(Canvas canvas) {
    var whitePaint = Paint()..color = Colors.white;

    for (final wall in walls) {
      canvas.drawLine(
        wall.origin.toOffset() / 2,
        (wall.origin + wall.direction).toOffset() / 2,
        whitePaint,
      );
    }

    //for (var i = -45; i < 45; i += 1) {
    for (var col = 0; col < gameRef.size.x; col += 1) {
      final i =
          atan((gameRef.size.x * col / 799 - 400) / 400) / degrees2Radians;
      final angle = (i + gameRef.azimuth) * degrees2Radians;
      final heading = Vector2(sin(angle), -cos(angle));
      final target = gameRef.origin + heading * gameRef.maxView;

      final x1 = gameRef.origin.x;
      final y1 = gameRef.origin.y;
      final x2 = target.x;
      final y2 = target.y;

      Vector2? nearestIntersection;
      double nearestDistance = 1.0 / 0.0;
      double nearestU = 0.0;
      Wall? nearestWall;

      for (final wall in walls) {
        // From wikipedia "Line-line intersection"
        // https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection

        final x3 = wall.origin.x;
        final y3 = wall.origin.y;
        final x4 = (wall.origin + wall.direction).x;
        final y4 = (wall.origin + wall.direction).y;

        final t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) /
            ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4));
        final u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) /
            ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4));

        if (t > 0 && t < 1 && u > 0 && u < 1) {
          final px = x1 + t * (x2 - x1);
          final py = y1 + t * (y2 - y1);
          final intersection = Vector2(px, py);
          final distance = (gameRef.origin - intersection).length;
          if (distance < nearestDistance) {
            nearestIntersection = intersection;
            nearestDistance = distance;
            nearestU = u;
            nearestWall = wall;
          }
        }
      }

      if (nearestIntersection != null) {
        canvas.drawLine(
          gameRef.origin.toOffset() / 2,
          nearestIntersection.toOffset() / 2,
          Paint()..color = Colors.grey,
        );
        if (nearestDistance <= 1000) {
          var dir = nearestIntersection - gameRef.origin;
          dir.rotate(-gameRef.azimuth * degrees2Radians);
          var perpendicularDistance = dir.y.abs();
          var c = 255 - (perpendicularDistance / 1000 * 255).toInt();
          var color = Colors.white.withRed(c).withGreen(c).withBlue(c);
          var length = 60 * gameRef.size.y / perpendicularDistance;
          var offset = (gameRef.size.y - length) / 2;

          nearestWall!.draw(canvas, nearestU, col, offset);
        }
      }
    }
  }
}
