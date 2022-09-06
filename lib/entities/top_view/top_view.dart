import 'dart:math';

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
    final size = gameRef.size;
    walls = [
      Wall(origin: Vector2(100, 100), direction: Vector2(100, 0)),
      Wall(origin: Vector2(200, 100), direction: Vector2(0, 100)),
      Wall(origin: Vector2(200, 300), direction: Vector2(0, 100)),
      Wall(origin: Vector2(200, 400), direction: Vector2(150, 0)),
      Wall(origin: Vector2(450, 400), direction: Vector2(150, 0)),
      Wall(origin: Vector2(600, 400), direction: Vector2(0, -100)),
      Wall(origin: Vector2(600, 200), direction: Vector2(0, -100)),
      Wall(origin: Vector2(600, 100), direction: Vector2(100, 0)),
      Wall(origin: Vector2(700, 100), direction: Vector2(0, 400)),
      Wall(origin: Vector2(700, 500), direction: Vector2(-600, 0)),
      Wall(origin: Vector2(100, 500), direction: Vector2(0, -400)),
      Wall(origin: Vector2(200, 100), direction: Vector2(150, 0)),
      Wall(origin: Vector2(450, 100), direction: Vector2(150, 0)),
      Wall(origin: Vector2(0, 0), direction: Vector2(size.x, 0)),
      Wall(origin: Vector2(gameRef.size.x, 0), direction: Vector2(0, size.y)),
      Wall(origin: Vector2(0, 0), direction: Vector2(0, size.y)),
      Wall(origin: Vector2(0, size.y), direction: Vector2(size.x, 0)),
    ];
  }

  @override
  void render(Canvas canvas) {
    var whitePaint = Paint()..color = Colors.white;

    for (final wall in walls) {
      canvas.drawLine(
        wall.origin.toOffset(),
        (wall.origin + wall.direction).toOffset(),
        whitePaint,
      );
    }

    for (var i = -45; i < 45; i += 1) {
      final angle = (i + gameRef.azimuth) * degrees2Radians;
      final heading = Vector2(sin(angle), -cos(angle));
      final target = gameRef.origin + heading * gameRef.maxView;

      final x1 = gameRef.origin.x;
      final y1 = gameRef.origin.y;
      final x2 = target.x;
      final y2 = target.y;

      Vector2? nearestIntersection;
      double nearestDistance = 1.0 / 0.0;

      for (final wall in walls) {
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
          }
        }
      }

      if (nearestIntersection != null) {
        canvas.drawLine(
          gameRef.origin.toOffset(),
          nearestIntersection.toOffset(),
          Paint()..color = Colors.grey,
        );
      }
    }
  }
}
