import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flolfenstein3d/entities/entities.dart';
import 'package:flolfenstein3d/wall.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Flolfenstein3DGame extends FlameGame
    with HasKeyboardHandlerComponents, MouseMovementDetector {
  @override
  Color backgroundColor() => const Color(0xff202020);

  Vector2 origin = Vector2(96, 260);

  var maxView = 1.0;
  var azimuth = 0.0;

  var walls = <Wall>[];
  late World world;

  @override
  Future<void> onLoad() async {
    // Set the viewport size
    camera.viewport = FixedResolutionViewport(
      Vector2(800, 600),
    );
    maxView = Vector2(size.x, size.y).length;

    await addAll([
      world = World(),
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

    // Wait until everything is loaded
    await ready();
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
