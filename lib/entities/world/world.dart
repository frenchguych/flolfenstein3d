import 'dart:math';
import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

import '../../flolfenstein_3d_game.dart';
import '../../game_block.dart';
import '../../wall.dart';
import 'behaviors/behaviors.dart';

class World extends Entity with HasGameRef<Flolfenstein3DGame> {
  World() : super(behaviors: [MovementBehavior()]);

  var gameBlocks = <GameBlock>[];
  var soldierX = 5 * 64 + 32;
  var soldierY = 5 * 64 + 32;
  late Image soldierTexture;
  late SpriteSheet soldierSpriteSheet;

  @override
  Future<void>? onLoad() async {
    final imagesLoader = Images();

    final bigSpriteSheet = SpriteSheet(
      image: await imagesLoader.load('S9Oxh7R.png'),
      srcSize: Vector2(65, 65),
    );

    var blueWallTexture = await bigSpriteSheet.getSprite(0, 14).toImage();
    var dorwayTexture = await bigSpriteSheet.getSprite(6, 4).toImage();
    soldierTexture = await bigSpriteSheet.getSprite(9, 12).toImage();
    soldierSpriteSheet =
        SpriteSheet(image: soldierTexture, srcSize: Vector2(1.0, 64.0));

    var blueCellWithSkelletonTexture =
        await bigSpriteSheet.getSprite(0, 12).toImage();

    /**
     *   01234567890 1 2 3 4 5 6 7 8 9
     * 0 XXXXXXXXXXX
     * 1 X         X
     * 2 X XXX XXX X
     * 3 X X     X X
     * 4 X         X
     * 5 X X     X X
     * 6 X X     X X
     * 7 X XXX XXX X
     * 8 X         X
     * 9 XXXXXXXXXXX 
     */

    gameBlocks = GameBlocks.start(
      GameBlock(x: 0, y: 0, walls: Walls.all(blueWallTexture)),
    )
        .east(Walls.all(blueWallTexture))
        .east(Walls.all(blueWallTexture))
        .east(Walls.all(blueWallTexture))
        .east(Walls.all(blueWallTexture))
        .east(Walls.all(blueWallTexture))
        .east(Walls.all(blueWallTexture))
        .east(Walls.all(blueWallTexture))
        .east(Walls.all(blueWallTexture))
        .east(Walls.all(blueWallTexture))
        .east(Walls.all(blueWallTexture))
        .south(Walls.all(blueWallTexture))
        .south(Walls.all(blueWallTexture))
        .south(Walls.all(blueWallTexture))
        .south(Walls.all(blueWallTexture))
        .south(Walls.all(blueWallTexture))
        .south(Walls.all(blueWallTexture))
        .south(Walls.all(blueWallTexture))
        .south(Walls.all(blueWallTexture))
        .south(Walls.all(blueWallTexture))
        .west(Walls.all(blueWallTexture))
        .west(Walls.all(blueWallTexture))
        .west(Walls.all(blueWallTexture))
        .west(Walls.all(blueWallTexture))
        .west(Walls.all(blueWallTexture))
        .west(Walls.all(blueWallTexture))
        .west(Walls.all(blueWallTexture))
        .west(Walls.all(blueWallTexture))
        .west(Walls.all(blueWallTexture))
        .west(Walls.all(blueWallTexture))
        .north(Walls.all(blueWallTexture))
        .north(Walls.all(blueWallTexture))
        .north(Walls.all(blueWallTexture))
        .north(Walls.all(blueWallTexture))
        .north(Walls.all(blueWallTexture))
        .north(Walls.all(blueWallTexture))
        .north(Walls.all(blueWallTexture))
        .north(Walls.all(blueWallTexture))
        .toList();

    /**
     *   01234567890 1 2 3 4 5 6 7 8 9
     * 0 XXXXXXXXXXX
     * 1 X         X
     * 2 X XXX XXX X
     * 3 X X     X X
     * 4 X         X
     * 5 X X     X X
     * 6 X X     X X
     * 7 X XXX XXX X
     * 8 X         X
     * 9 XXXXXXXXXXX 
     */

    gameBlocks = [
      ...gameBlocks,
      ...GameBlocks.start(
        GameBlock(x: 2, y: 2, walls: Walls.all(blueWallTexture)),
      )
          .east(Walls.all(blueWallTexture))
          .east(Walls.fromNSEW(
            northTexture: blueWallTexture,
            eastTexture: dorwayTexture,
            southTexture: blueWallTexture,
            westTexture: blueWallTexture,
          ))
          .east(
              Walls.fromNSEW(
                northTexture: blueWallTexture,
                eastTexture: blueWallTexture,
                southTexture: blueWallTexture,
                westTexture: dorwayTexture,
              ),
              skip: 1)
          .east(Walls.all(blueWallTexture))
          .east(Walls.all(blueWallTexture))
          .south(Walls.fromNSEW(
            northTexture: blueWallTexture,
            eastTexture: blueWallTexture,
            southTexture: dorwayTexture,
            westTexture: blueWallTexture,
          ))
          .south(
              Walls.fromNSEW(
                northTexture: dorwayTexture,
                eastTexture: blueWallTexture,
                southTexture: blueWallTexture,
                westTexture: blueWallTexture,
              ),
              skip: 1)
          .south(Walls.all(blueWallTexture))
          .south(Walls.all(blueWallTexture))
          .west(Walls.all(blueWallTexture))
          .west(Walls.fromNSEW(
            northTexture: blueWallTexture,
            eastTexture: blueWallTexture,
            southTexture: blueWallTexture,
            westTexture: dorwayTexture,
          ))
          .west(
              Walls.fromNSEW(
                northTexture: blueWallTexture,
                eastTexture: dorwayTexture,
                southTexture: blueWallTexture,
                westTexture: blueWallTexture,
              ),
              skip: 1)
          .west(Walls.all(blueWallTexture))
          .west(Walls.all(blueWallTexture))
          .north(Walls.all(blueWallTexture))
          .north(Walls.fromNSEW(
            northTexture: dorwayTexture,
            eastTexture: blueWallTexture,
            southTexture: blueWallTexture,
            westTexture: blueWallTexture,
          ))
          .north(
              Walls.fromNSEW(
                northTexture: blueWallTexture,
                eastTexture: blueWallTexture,
                southTexture: dorwayTexture,
                westTexture: blueWallTexture,
              ),
              skip: 1)
          .toList(),
    ];
  }

  var distances = List<double>.filled(800, 0.0);
  final leftLimit = atan(-400 / 600);
  final rightLimit = atan(400 / 600);

  @override
  void render(Canvas canvas) {
    for (var col = 0; col < gameRef.size.x; col += 1) {
      // 400 = half the viewport size (camera plane)
      // 600 = distance from the player to the camera plane

      final i =
          atan((400 - gameRef.size.x * col / 799) / 600) / degrees2Radians;
      final angle = (i + gameRef.azimuth) * degrees2Radians;

      /*

          /
        /
      /
      \
       \
        \
      
      */

      final heading = Vector2(-sin(angle), -cos(angle));
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
        for (final wall in block.walls.toList()) {
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

      distances[col] = nearestDistance;
      if (nearestIntersection != null) {
        if (nearestDistance <= 1000) {
          var dir = nearestIntersection - gameRef.origin;
          dir.rotate(gameRef.azimuth * degrees2Radians);
          var perpendicularDistance = dir.y.abs();
          var length = 64 * gameRef.size.y / perpendicularDistance;
          var offset = (gameRef.size.y - length) / 2;

          nearestWall!.draw(canvas, nearestU, col, offset);
        }
      }
    }

    //       +
    //      /
    // ___/
    //  /
    // *

    final soldierVect = Vector2(
      soldierX - gameRef.origin.x,
      soldierY - gameRef.origin.y,
    );

    final azimuthVect = Vector2(
      -sin(gameRef.azimuth * degrees2Radians),
      -cos(gameRef.azimuth * degrees2Radians),
    );

    /* Angle from the azimuth to the soldier */
    var soldierAngle = -azimuthVect.angleToSigned(soldierVect);

    /* Perpendicular distance from the player to the soldier */
    final perpendicularDistance = cos(soldierAngle).abs() * soldierVect.length;
    final colinearDistance = sin(soldierAngle).abs() * soldierVect.length;

    if (colinearDistance < perpendicularDistance) {
      /* Solider's sprite's height */
      /* Since the sprite is 64x64, the sprite's width is the same */
      final spriteSize = 64 * gameRef.size.y / perpendicularDistance;

      /* The screen column where the left side of the sprite should be drawn */
      final col =
          799 - (799 * (soldierAngle - leftLimit) / (rightLimit - leftLimit));
      final colLeft = (col - spriteSize / 2).floor();
      final colRight = (col + spriteSize / 2).ceil();

      for (var col = colLeft; col <= colRight; col++) {
        if (col < 0 || col >= 800) {
          continue;
        }
        final distance = distances[col];
        if (distance < perpendicularDistance) {
          continue;
        }

        var u = 63 * (col - colLeft) / (colRight - colLeft);
        final sprite = soldierSpriteSheet.getSpriteById(u.floor());
        sprite.render(
          canvas,
          position: Vector2(col.toDouble(), 300 - spriteSize / 2),
          size: Vector2(1, spriteSize),
        );

        //canvas.drawLine(
        //  Vector2(col.toDouble(), 300 - spriteSize / 2).toOffset(),
        //  Vector2(col.toDouble(), 300 + spriteSize / 2).toOffset(),
        //  Paint()..color = Colors.red,
        //);
        //final u = (col - colLeft) / spriteSize;
        //final offset = (gameRef.size.y - spriteSize) / 2;
        //soldierSprite.draw(canvas, u, col, offset);
      }
    }

    //debugPrint(perpendicularDistance.toStringAsFixed(2));
    //if (soldierAngle >= leftLimit && soldierAngle <= rightLimit) {
    //  final perpendicularDistance = cos(soldierAngle) * soldierVect.length;
    //  final col =
    //      799 - (799 * (soldierAngle - leftLimit) / (rightLimit - leftLimit));
    //  final iCol = col.round();
    //  if (iCol >= 0 && iCol < 800 && perpendicularDistance < distances[iCol]) {
    //    final height = 64 * gameRef.size.y / perpendicularDistance;
    //    final offset = (gameRef.size.y - height) / 2;
    //    //canvas.drawLine(
    //    //  Vector2(col, offset).toOffset(),
    //    //  Vector2(col, 599 - offset).toOffset(),
    //    //  Paint()..color = Colors.red,
    //    //);
    //    Sprite sp = Sprite(
    //      soldierTexture,
    //      srcSize: Vector2(64, 64),
    //    );
    //    sp.render(canvas,
    //        position: Vector2(col, offset),
    //        size: Vector2(32768 / perpendicularDistance, height));
    //  }
    //}
  }

  double oldDx = 1.0 / 0.0;
  double oldDy = 1.0 / 0.0;
  double oldAngle = 1.0 / 0.0;
}
