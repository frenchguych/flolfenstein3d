import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flolfenstein3d/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Wall {
  Vector2 origin;
  Vector2 direction;
  Sprite sprite;
  final double width;

  Wall({
    required this.origin,
    required this.direction,
    required this.sprite,
  }) : width = sprite.srcSize.x;

  void draw(Canvas canvas, double nearestU, int col, double offset) {
    final srcSize = sprite.srcSize;
    sprite.srcSize = Vector2(1, 100);
    sprite.srcPosition = Vector2(nearestU * width, 0);
    sprite.render(
      canvas,
      position: Vector2(400, 0) + Vector2(col * 1.0, offset) / 2,
      size: Vector2(1, 600 - 2 * offset) / 2,
    );
    sprite.srcSize = srcSize;
  }
}

class Flolfenstein3DGame extends FlameGame
    with HasKeyboardHandlerComponents, MouseMovementDetector {
  @override
  Color backgroundColor() => const Color(0xff202020);

  Vector2 origin = Vector2(400, 490);

  var maxView = 1.0;
  var azimuth = 0.0;

  var walls = <Wall>[];

  @override
  Future<void> onLoad() async {
    // Set the viewport size
    camera.viewport = FixedResolutionViewport(
      Vector2(800, 600),
    );
    maxView = Vector2(size.x, size.y).length;

    await addAll([
      TopView(),
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
  @mustCallSuper
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);
    return KeyEventResult.handled;
  }
}
