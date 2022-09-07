import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/services.dart';

import '../../../flolfenstein_3d_game.dart';
import '../top_view.dart';

class TopViewTogglerBehavior extends Behavior<TopView>
    with HasGameRef<Flolfenstein3DGame>, KeyboardHandler {
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.keyT)) {
        gameRef.toggleTopView();
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
