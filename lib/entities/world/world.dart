import 'dart:math';
import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

import '../../flolfenstein_3d_game.dart';
import '../../game_block.dart';
import '../../wall.dart';
import '../top_view/behaviors/movement_behavior.dart';

var gameBlocks = <GameBlock>[];

class World extends Entity with HasGameRef<Flolfenstein3DGame> {
  World() : super(behaviors: [MovementBehavior()]);

  @override
  Future<void>? onLoad() async {
    final imagesLoader = Images();

    final bigSpriteSheet = SpriteSheet(
      image: await imagesLoader.load('S9Oxh7R.png'),
      srcSize: Vector2(65, 65),
    );

    var blueWallTexture = await bigSpriteSheet.getSpriteById(14).toImage();

    var blueCellWithSkelletonTexture =
        await bigSpriteSheet.getSpriteById(12).toImage();

    gameBlocks = [
      GameBlock(
          x: 0,
          y: 1,
          walls: Walls.fromNSEW(
            west: blueWallTexture,
            south: blueCellWithSkelletonTexture,
            east: blueWallTexture,
            north: blueWallTexture,
          )),
      GameBlock(
          x: 1,
          y: 1,
          walls: Walls.fromNSEW(
            west: blueWallTexture,
            south: blueCellWithSkelletonTexture,
            east: blueWallTexture,
            north: blueWallTexture,
          )),
      GameBlock(
          x: 2,
          y: 1,
          walls: Walls.fromNSEW(
            west: blueWallTexture,
            south: blueCellWithSkelletonTexture,
            east: blueWallTexture,
            north: blueWallTexture,
          )),
    ];
  }

  @override
  void render(Canvas canvas) {
    for (var col = 0; col < gameRef.size.x; col += 1) {
      final i =
          atan((gameRef.size.x * col / 799 - 400) / 600) / degrees2Radians;
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

      for (final block in gameBlocks) {
        for (final wall in block.walls) {
          final x3 = (block.x + wall.origin.x) * 64;
          final y3 = (block.y + wall.origin.y) * 64;
          final x4 = (block.x + wall.origin.x + wall.direction.x) * 64;
          final y4 = (block.y + wall.origin.y + wall.direction.y) * 64;

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
      }

      if (nearestIntersection != null) {
        if (nearestDistance <= 1000) {
          var dir = nearestIntersection - gameRef.origin;
          dir.rotate(-gameRef.azimuth * degrees2Radians);
          var perpendicularDistance = dir.y.abs();
          var length = 64 * gameRef.size.y / perpendicularDistance;
          var offset = (gameRef.size.y - length) / 2;

          nearestWall!.draw(canvas, nearestU, col, offset);
        }
      }
    }
  }
}
