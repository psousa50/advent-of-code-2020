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

class ShipPart1 {
  final Position position;
  final Direction direction;
  final Position waypoint;

  ShipPart1(this.position, this.direction, this.waypoint);

  static ShipPart1 north(ShipPart1 ship, int op) =>
      ship.copyWith(position: ship.position.moveY(op));
  static ShipPart1 south(ShipPart1 ship, int op) =>
      ship.copyWith(position: ship.position.moveY(-op));
  static ShipPart1 east(ShipPart1 ship, int op) =>
      ship.copyWith(position: ship.position.moveX(op));
  static ShipPart1 west(ShipPart1 ship, int op) =>
      ship.copyWith(position: ship.position.moveX(-op));

  static ShipPart1 forward(ShipPart1 ship, int op) => ship.copyWith(
        position: ship.position + directionMoveForward[ship.direction] * op,
      );

  static ShipPart1 left(ShipPart1 ship, int op) => ship.copyWith(
        direction: ship.direction.rotateLeft(op ~/ 90),
      );

  static ShipPart1 right(ShipPart1 ship, int op) => ship.copyWith(
        direction: ship.direction.rotateRight(op ~/ 90),
      );

  @override
  String toString() {
    return '$position $direction';
  }

  ShipPart1 copyWith({
    Position position,
    Direction direction,
    Position waypoint,
  }) {
    return ShipPart1(
      position ?? this.position,
      direction ?? this.direction,
      waypoint ?? this.waypoint,
    );
  }
}

Command parseCommand(String line) {
  return Command(
    enumFromString(Action.values, line[0]),
    int.parse(line.substring(1)),
  );
}

var commands = {
  Action.N: ShipPart1.north,
  Action.S: ShipPart1.south,
  Action.E: ShipPart1.east,
  Action.W: ShipPart1.west,
  Action.L: ShipPart1.left,
  Action.R: ShipPart1.right,
  Action.F: ShipPart1.forward,
};

ShipPart1 executePart1(ShipPart1 ship, Command c) {
  return commands[c.action](ship, c.operand);
}

int day12_part1() {
  var lines = readLines(12, 'data');

  var initialShip = ShipPart1(Position(0, 0), Direction.East, Position(1, 1));
  var finalShip = lines.map(parseCommand).fold(initialShip, executePart1);

  return finalShip.position.x.abs() + finalShip.position.y.abs();
}

class ShipPart2 {
  final Position position;
  final Direction direction;
  final Position waypoint;

  ShipPart2(this.position, this.direction, this.waypoint);

  static ShipPart2 north(ShipPart2 ship, int op) =>
      ship.copyWith(waypoint: ship.waypoint.moveY(op));
  static ShipPart2 south(ShipPart2 ship, int op) =>
      ship.copyWith(waypoint: ship.waypoint.moveY(-op));
  static ShipPart2 east(ShipPart2 ship, int op) =>
      ship.copyWith(waypoint: ship.waypoint.moveX(op));
  static ShipPart2 west(ShipPart2 ship, int op) =>
      ship.copyWith(waypoint: ship.waypoint.moveX(-op));

  static ShipPart2 forward(ShipPart2 ship, int op) => ship.copyWith(
        position: ship.position + ship.waypoint * op,
      );

  static ShipPart2 left(ShipPart2 ship, int op) => ship.copyWith(
        waypoint: ship.waypoint.rotateLeft(op ~/ 90),
      );

  static ShipPart2 right(ShipPart2 ship, int op) => ship.copyWith(
        waypoint: ship.waypoint.rotateRight(op ~/ 90),
      );

  @override
  String toString() {
    return '$position $direction $waypoint';
  }

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

var commandsPart2 = {
  Action.N: ShipPart2.north,
  Action.S: ShipPart2.south,
  Action.E: ShipPart2.east,
  Action.W: ShipPart2.west,
  Action.L: ShipPart2.left,
  Action.R: ShipPart2.right,
  Action.F: ShipPart2.forward,
};

ShipPart2 executePart2(ShipPart2 ship, Command c) {
  return commandsPart2[c.action](ship, c.operand);
}

int day12_part2() {
  var lines = readLines(12, 'data');

  var initialShip = ShipPart2(Position(0, 0), Direction.East, Position(10, 1));
  var finalShip = lines.map(parseCommand).fold(initialShip, executePart2);

  return finalShip.position.x.abs() + finalShip.position.y.abs();
}
