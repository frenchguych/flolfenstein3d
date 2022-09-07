import 'package:flolfenstein3d/wall.dart';

class GameBlock {
  final int x;
  final int y;
  final Walls walls;

  GameBlock? north;
  GameBlock? south;
  GameBlock? east;
  GameBlock? west;

  GameBlock({
    required this.x,
    required this.y,
    required this.walls,
  });
}

class GameBlocks {
  final blocks = <GameBlock>[];

  GameBlocks._();

  static GameBlocks start(GameBlock startBlock) {
    final gameBlocks = GameBlocks._();
    gameBlocks.blocks.add(startBlock);
    return gameBlocks;
  }

  GameBlocks east(Walls walls, {int? skip}) {
    assert(skip == null || skip > 0);
    final lastBlock = blocks.last;
    final newBlock = GameBlock(
      x: lastBlock.x + 1 + (skip ?? 0),
      y: lastBlock.y,
      walls: walls,
    );
    lastBlock.east = newBlock;
    newBlock.west = lastBlock;
    if (skip == null) {
      lastBlock.walls.east = null;
      newBlock.walls.west = null;
    }
    blocks.add(newBlock);
    return this;
  }

  GameBlocks west(Walls walls, {int? skip}) {
    assert(skip == null || skip > 0);
    final lastBlock = blocks.last;
    final newBlock = GameBlock(
      x: lastBlock.x - 1 - (skip ?? 0),
      y: lastBlock.y,
      walls: walls,
    );
    lastBlock.west = newBlock;
    newBlock.east = lastBlock;
    if (skip == null) {
      lastBlock.walls.west = null;
      newBlock.walls.east = null;
    }
    blocks.add(newBlock);
    return this;
  }

  GameBlocks north(Walls walls, {int? skip}) {
    assert(skip == null || skip > 0);
    final lastBlock = blocks.last;
    final newBlock = GameBlock(
      x: lastBlock.x,
      y: lastBlock.y - 1 - (skip ?? 0),
      walls: walls,
    );
    lastBlock.north = newBlock;
    newBlock.south = lastBlock;
    if (skip == null) {
      lastBlock.walls.north = null;
      newBlock.walls.south = null;
    }
    blocks.add(newBlock);
    return this;
  }

  GameBlocks south(Walls walls, {int? skip}) {
    assert(skip == null || skip > 0);
    final lastBlock = blocks.last;
    final newBlock = GameBlock(
      x: lastBlock.x,
      y: lastBlock.y + 1 + (skip ?? 0),
      walls: walls,
    );
    lastBlock.south = newBlock;
    newBlock.north = lastBlock;
    if (skip == null) {
      lastBlock.walls.south = null;
      newBlock.walls.north = null;
    }
    blocks.add(newBlock);
    return this;
  }

  List<GameBlock> toList() {
    return blocks;
  }
}
