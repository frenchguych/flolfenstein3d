import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Wall {
  Vector2 origin;
  Vector2 direction;
  Wall({
    required this.origin,
    required this.direction,
  });
}

class Flolfenstein3DGame extends FlameGame
    with HasKeyboardHandlerComponents, MouseMovementDetector {
  @override
  Color backgroundColor() => const Color(0xff202020);

  Vector2 origin = Vector2.all(100);

  var lookup = 1.0;

  @override
  void onMouseMove(PointerHoverInfo info) {
    final position = info.eventPosition.game;
    if (position.x >= 0 &&
        position.x <= size.x &&
        position.y >= 0 &&
        position.y <= size.y) {
      origin = position;
    }
  }

  var walls = <Wall>[];

  @override
  Future<void> onLoad() async {
    // Set the viewport size
    camera.viewport = FixedResolutionViewport(
      Vector2(800, 600),
    );
    lookup = Vector2(size.x, size.y).length;

    //final rnd = Random();
    //walls = List.generate(3, (index) {
    //  var origin = Vector2(
    //    rnd.nextDouble() * size.x,
    //    rnd.nextDouble() * size.y,
    //  );
    //  var direction = Vector2(
    //        rnd.nextDouble() * size.x,
    //        rnd.nextDouble() * size.y,
    //      ) -
    //      origin;
    //  return Wall(
    //    origin: origin,
    //    direction: direction,
    //  );
    //});
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
      Wall(origin: Vector2(size.x, 0), direction: Vector2(0, size.y)),
      Wall(origin: Vector2(0, 0), direction: Vector2(0, size.y)),
      Wall(origin: Vector2(0, size.y), direction: Vector2(size.x, 0)),
    ];

    await addAll([
      FpsTextComponent(
        position: Vector2(0, 0),
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 20,
            color: Colors.green,
          ),
        ),
      )
    ]);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    camera.viewport.apply(canvas);
    //canvas.drawRect(
    //  Rect.fromLTWH(0, 0, size.x, size.y),
    //  Paint()..color = Colors.black,
    //);

    var whitePaint = Paint()..color = Colors.white;

    //canvas.drawCircle(origin.toOffset(), 2, Paint()..color = Colors.white);
    //canvas.drawLine(
    //  Vector2(450, 150).toOffset(),
    //  Vector2(450, 450).toOffset(),
    //  whitePaint,
    //);
    for (final wall in walls) {
      canvas.drawLine(
        wall.origin.toOffset(),
        (wall.origin + wall.direction).toOffset(),
        whitePaint,
      );
    }

    for (var i = 0; i < 360; i += 1) {
      final angle = i * degrees2Radians;
      final heading = Vector2(sin(angle), -cos(angle));
      final target = origin + heading * lookup;

      final x1 = origin.x;
      final y1 = origin.y;
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
          final distance = (origin - intersection).length;
          if (distance < nearestDistance) {
            nearestIntersection = intersection;
            nearestDistance = distance;
          }
        }
      }

      if (nearestIntersection != null) {
        canvas.drawLine(
          origin.toOffset(),
          nearestIntersection.toOffset(),
          Paint()..color = Colors.grey,
        );
      }

      /* For infinite lines */
      /*
      final den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
      final numx =
          (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4);
      final numy =
          (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4);

      if (den != 0) {
        var px = numx / den;
        var py = numy / den;

        canvas.drawLine(
          origin.toOffset(),
          Vector2(px, py).toOffset(),
          Paint()..color = Colors.grey,
        );
      }
      */
    }
    canvas.restore();
    super.render(canvas);
  }
}
