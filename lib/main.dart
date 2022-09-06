import 'package:flame/game.dart';
import 'package:flolfenstein3d/flolfenstein_3d_game.dart';
import 'package:flutter/material.dart';

void main() {
  final game = Flolfenstein3DGame();
  runApp(
    GameWidget(
      game: game,
    ),
  );
}
