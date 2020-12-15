import '../common.dart';

enum Direction {
  North,
  East,
  South,
  West,
}

var rotateLeftMap = {
  Direction.North: Direction.West,
  Direction.East: Direction.North,
  Direction.South: Direction.East,
  Direction.West: Direction.South,
};

var rotateRightMap = {
  Direction.North: Direction.East,
  Direction.East: Direction.South,
  Direction.South: Direction.West,
  Direction.West: Direction.North,
};

extension DirectionExtension on Direction {
  Direction rotateLeft(int count) =>
      Iterable.generate(count).fold(this, (d, _) => rotateLeftMap[d]);
  Direction rotateRight(int count) =>
      Iterable.generate(count).fold(this, (d, _) => rotateRightMap[d]);
}

enum Action { N, S, E, W, L, R, F }

var directionMoveForward = {
  Direction.North: Position(0, 1),
  Direction.South: Position(0, -1),
  Direction.East: Position(1, 0),
  Direction.West: Position(-1, 0),
};

class Command {
  final Action action;
  final int operand;

  Command(this.action, this.operand);

  @override
  String toString() {
    return '$action $operand';
  }
}

class Position {
  final int x;
  final int y;

  Position(this.x, this.y);

  Position operator *(int v) {
    return Position(x * v, y * v);
  }

  Position operator +(Position p) {
    return Position(x + p.x, y + p.y);
  }

  Position operator -(Position p) {
    return Position(x - p.x, y - p.y);
  }

  Position moveX(int x) {
    return this + Position(x, 0);
  }

  Position moveY(int y) {
    return this + Position(0, y);
  }

  Position rotateLeft(int count) {
    var x1 = x;
    var y1 = y;
    for (var i = 0; i < count; i++) {
      var t = x1;
      x1 = -y1;
      y1 = t;
    }
    return Position(x1, y1);
  }

  Position rotateRight(int count) {
    var x1 = x;
    var y1 = y;
    for (var i = 0; i < count; i++) {
      var t = x1;
      x1 = y1;
      y1 = -t;
    }
    return Position(x1, y1);
  }

  @override
  String toString() {
    return '($x,$y)';
  }
}

Command parseCommand(String line) {
  return Command(
    enumFromString(Action.values, line[0]),
    int.parse(line.substring(1)),
  );
}

abstract class Ship {
  final Position position;
  final Direction direction;

  Ship(this.position, this.direction);

  Ship north(int op);
  Ship south(int op);
  Ship east(int op);
  Ship west(int op);
  Ship forward(int op);
  Ship left(int op);
  Ship right(int op);

  @override
  String toString() {
    return '$position $direction';
  }

  Ship execute(Command c) {
    switch (c.action) {
      case Action.N:
        return north(c.operand);
      case Action.E:
        return east(c.operand);
      case Action.S:
        return south(c.operand);
      case Action.W:
        return west(c.operand);
      case Action.L:
        return left(c.operand);
      case Action.R:
        return right(c.operand);
      case Action.F:
        return forward(c.operand);
    }
    return this;
  }
}

class ShipPart1 extends Ship {
  ShipPart1(Position position, Direction direction)
      : super(position, direction);

  @override
  Ship north(int op) => copyWith(position: position.moveY(op));
  @override
  Ship south(int op) => copyWith(position: position.moveY(-op));
  @override
  Ship east(int op) => copyWith(position: position.moveX(op));
  @override
  Ship west(int op) => copyWith(position: position.moveX(-op));
  @override
  Ship forward(int op) =>
      copyWith(position: position + directionMoveForward[direction] * op);
  @override
  Ship left(int op) => copyWith(direction: direction.rotateLeft(op ~/ 90));
  @override
  Ship right(int op) => copyWith(direction: direction.rotateRight(op ~/ 90));

  ShipPart1 copyWith({
    Position position,
    Direction direction,
  }) {
    return ShipPart1(
      position ?? this.position,
      direction ?? this.direction,
    );
  }
}

int day12_part1() {
  var lines = readLines(12, 'data');

  var initialShip = ShipPart1(Position(0, 0), Direction.East);
  var finalShip =
      lines.map(parseCommand).fold(initialShip, (s, c) => s.execute(c));

  return finalShip.position.x.abs() + finalShip.position.y.abs();
}

class ShipPart2 extends Ship {
  final Position waypoint;

  ShipPart2(Position position, Direction direction, this.waypoint)
      : super(position, direction);

  @override
  Ship north(int op) => copyWith(waypoint: waypoint.moveY(op));
  @override
  Ship south(int op) => copyWith(waypoint: waypoint.moveY(-op));
  @override
  Ship east(int op) => copyWith(waypoint: waypoint.moveX(op));
  @override
  Ship west(int op) => copyWith(waypoint: waypoint.moveX(-op));
  @override
  Ship forward(int op) => copyWith(position: position + waypoint * op);
  @override
  Ship left(int op) => copyWith(waypoint: waypoint.rotateLeft(op ~/ 90));
  @override
  Ship right(int op) => copyWith(waypoint: waypoint.rotateRight(op ~/ 90));

  ShipPart2 copyWith({
    Position position,
    Direction direction,
    Position waypoint,
  }) {
    return ShipPart2(
      position ?? this.position,
      direction ?? this.direction,
      waypoint ?? this.waypoint,
    );
  }
}

int day12_part2() {
  var lines = readLines(12, 'data');

  var initialShip = ShipPart2(Position(0, 0), Direction.East, Position(10, 1));
  var finalShip =
      lines.map(parseCommand).fold(initialShip, (s, c) => s.execute(c));

  return finalShip.position.x.abs() + finalShip.position.y.abs();
}
