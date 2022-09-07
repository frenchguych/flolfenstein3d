import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flolfenstein3d/entities/entities.dart';
import 'package:flolfenstein3d/flolfenstein_3d_game.dart';
import 'package:flutter/services.dart';

class MovementBehavior extends Behavior<World>
    with HasGameRef<Flolfenstein3DGame>, KeyboardHandler {
  final Vector2 _velocity = Vector2.zero();
  final _speed = 150.0;
  var _rotationVelocity = 0.0;
  final _rotationSpeed = 150.0;

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final bool isAltDown = keysPressed.contains(LogicalKeyboardKey.altLeft) ||
        keysPressed.contains(LogicalKeyboardKey.altRight);

    _velocity.setZero();
    _rotationVelocity = 0.0;
    /* Move forawrd */
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) &&
        !keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      _velocity.y = -_speed;
    }
    /* Move backward */
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown) &&
        !keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      _velocity.y = _speed;
    }
    /* Strafe left */
    if (isAltDown &&
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) &&
        !keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _velocity.x = -_speed;
    }
    /* Strafe right */
    if (isAltDown &&
        keysPressed.contains(LogicalKeyboardKey.arrowRight) &&
        !keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _velocity.x = _speed;
    }
    /* Turn left */
    if (!isAltDown &&
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) &&
        !keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _rotationVelocity = -_rotationSpeed;
    }
    /* Turn right */
    if (!isAltDown &&
        keysPressed.contains(LogicalKeyboardKey.arrowRight) &&
        !keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _rotationVelocity = _rotationSpeed;
    }
    return false;
  }

  @override
  void update(double dt) {
    gameRef.azimuth += _rotationVelocity * dt;

    /* 
     * We need to clone the velocity vector because we are going to rotate it
     * and we might get multime updates before the next key event. If we were
     * to rotate the velocity vector in place, we would end up with multiple 
     * rotations.
     */
    final v = _velocity.clone();
    v.rotate(gameRef.azimuth * degrees2Radians);
    gameRef.origin += v * dt;
  }
}
