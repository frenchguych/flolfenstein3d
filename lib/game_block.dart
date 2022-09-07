import 'package:flolfenstein3d/wall.dart';

class GameBlock {
  final int x;
  final int y;
  final List<Wall> walls;

  GameBlock({
    required this.x,
    required this.y,
    required this.walls,
  });
}
