import '../common.dart';

enum Direction {
  North,
  East,
  South,
  West,
}

extension DirectionExtension on Direction {
  Direction rotate(int o) {
    var v = Direction.values;
    var l = v.length;
    return v[((v.indexOf(this) + o + l) % l)];
  }

  void talk() {
    print('meow');
  }
}

enum Action {
  N,
  S,
  E,
  W,
  L,
  R,
  F,
}

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

  Position moveX(int x) {
    return this + Position(x, 0);
  }

  Position moveY(int y) {
    return this + Position(0, y);
  }

  @override
  String toString() {
    return '($x,$y)';
  }
}

class Ship {
  final Position position;
  final Direction direction;

  Ship(this.position, this.direction);

  static Ship north(Ship ship, int op) =>
      Ship(ship.position.moveY(op), ship.direction);
  static Ship south(Ship ship, int op) =>
      Ship(ship.position.moveY(-op), ship.direction);
  static Ship east(Ship ship, int op) =>
      Ship(ship.position.moveX(op), ship.direction);
  static Ship west(Ship ship, int op) =>
      Ship(ship.position.moveX(-op), ship.direction);

  static Ship forward(Ship ship, int op) => Ship(
        ship.position + directionMoveForward[ship.direction] * op,
        ship.direction,
      );

  static Ship left(Ship ship, int op) => Ship(
        ship.position,
        ship.direction.rotate(-op ~/ 90),
      );

  static Ship right(Ship ship, int op) => Ship(
        ship.position,
        ship.direction.rotate(op ~/ 90),
      );

  @override
  String toString() {
    return '$position $direction';
  }
}

Command parseCommand(String line) {
  return Command(
    enumFromString(Action.values, line[0]),
    int.parse(line.substring(1)),
  );
}

var commands = {
  Action.N: Ship.north,
  Action.S: Ship.south,
  Action.E: Ship.east,
  Action.W: Ship.west,
  Action.L: Ship.left,
  Action.R: Ship.right,
  Action.F: Ship.forward,
};

Ship execute(Ship ship, Command c) {
  return commands[c.action](ship, c.operand);
}

int day12_part1() {
  var lines = readLines(12, 'data');

  var initialShip = Ship(Position(0, 0), Direction.East);
  var finalShip = lines.map(parseCommand).fold(initialShip, execute);

  return finalShip.position.x.abs() + finalShip.position.y.abs();
}

int day12_part2() {
  var lines = readLines(12, 'sample');

  return 0;
}
