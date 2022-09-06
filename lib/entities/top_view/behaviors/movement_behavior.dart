import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flolfenstein3d/entities/top_view/top_view.dart';
import 'package:flolfenstein3d/flolfenstein_3d_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MovementBehavior extends Behavior<TopView>
    with HasGameRef<Flolfenstein3DGame>, KeyboardHandler {
  final Vector2 _velocity = Vector2.zero();
  final _speed = 100.0;
  var _rotationVelocity = 0.0;
  final _rotationSpeed = 150.0;

  MovementBehavior(
    LogicalKeyboardKey moveForward,
    LogicalKeyboardKey moveBackward,
    LogicalKeyboardKey turnLeft,
    LogicalKeyboardKey turnRight,
    LogicalKeyboardKey strafeLeft,
    LogicalKeyboardKey strafeRight,
  )   : _moveForward = moveForward,
        _moveBackward = moveBackward,
        _turnLeft = turnLeft,
        _turnRight = turnRight,
        _strafeLeft = strafeLeft,
        _strafeRight = strafeRight;

  final LogicalKeyboardKey _moveForward;
  final LogicalKeyboardKey _moveBackward;
  final LogicalKeyboardKey _turnLeft;
  final LogicalKeyboardKey _turnRight;
  final LogicalKeyboardKey _strafeLeft;
  final LogicalKeyboardKey _strafeRight;

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _velocity.setZero();
    _rotationVelocity = 0.0;
    if (keysPressed.contains(_moveForward) &&
        !keysPressed.contains(_moveBackward)) {
      _velocity.y = -_speed;
    }
    if (keysPressed.contains(_moveBackward) &&
        !keysPressed.contains(_moveForward)) {
      _velocity.y = _speed / 2;
    }
    if (keysPressed.contains(_strafeLeft) &&
        !keysPressed.contains(_strafeRight)) {
      _velocity.x = -_speed / 2;
    }
    if (keysPressed.contains(_strafeRight) &&
        !keysPressed.contains(_strafeLeft)) {
      _velocity.x = _speed / 2;
    }
    if (keysPressed.contains(_turnRight) && !keysPressed.contains(_turnLeft)) {
      _rotationVelocity = _rotationSpeed;
    }
    if (keysPressed.contains(_turnLeft) && !keysPressed.contains(_turnRight)) {
      _rotationVelocity = -_rotationSpeed;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    if (_rotationVelocity > 0.0 || _velocity.length > 0.0) {
      debugPrint(
          '_rotationVelocity: $_rotationVelocity, _velocity: $_velocity');
    }
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
