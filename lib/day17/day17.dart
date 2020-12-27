import 'dart:math';

import '../common.dart';

class Point {
  final int x;
  final int y;
  final int z;

  Point(this.x, this.y, this.z);

  @override
  String toString() {
    return '$x $y $z';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Point && o.x == x && o.y == y && o.z == z;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;
}

class Cube extends Point {
  Cube(int x, int y, int z) : super(x, y, z);

  List<Cube> neighbours2D(int zOffset) {
    return [
      Cube(x - 1, y - 1, z - zOffset),
      Cube(x - 0, y - 1, z - zOffset),
      Cube(x + 1, y - 1, z - zOffset),
      Cube(x - 1, y + 0, z - zOffset),
      Cube(x - 0, y + 0, z - zOffset),
      Cube(x + 1, y + 0, z - zOffset),
      Cube(x - 1, y + 1, z - zOffset),
      Cube(x - 0, y + 1, z - zOffset),
      Cube(x + 1, y + 1, z - zOffset),
    ];
  }

  List<Cube> neighbours() {
    return neighbours2D(-1)
      ..addAll(neighbours2D(0)..addAll(neighbours2D(1)))
      ..remove(this);
  }
}

class World {
  List<Cube> cubes;

  World(this.cubes);

  bool isActive(Cube other) {
    return cubes.contains(other);
  }

  Iterable<Cube> activeNeighbours(Cube cube) {
    return cube.neighbours().where(isActive);
  }

  void cycle() {
    var newCubes = List<Cube>.from(cubes.where((cube) {
      return [2, 3].contains(activeNeighbours(cube).length);
    }));
    var minX = cubes.map((c) => c.x).reduce(min);
    var maxX = cubes.map((c) => c.x).reduce(max);
    var minY = cubes.map((c) => c.y).reduce(min);
    var maxY = cubes.map((c) => c.y).reduce(max);
    var minZ = cubes.map((c) => c.z).reduce(min);
    var maxZ = cubes.map((c) => c.z).reduce(max);

    for (var x = minX - 1; x <= maxX + 1; x++) {
      for (var y = minY - 1; y <= maxY + 1; y++) {
        for (var z = minZ - 1; z <= maxZ + 1; z++) {
          var thisCube = Cube(x, y, z);
          if (!isActive(thisCube) && activeNeighbours(thisCube).length == 3) {
            newCubes.add(thisCube);
          }
        }
      }
    }

    cubes = newCubes;
  }

  @override
  String toString() {
    return '$cubes';
  }
}

List<Cube> parseLines(List<String> lines) {
  var cubes = <Cube>[];

  for (var y = 0; y < lines.length; y++) {
    cubes.addAll(
      lines[y].split('').mapIndexed((a, x) => a == '#' ? Cube(x, y, 0) : null),
    );
  }

  return cubes.where((c) => c != null).toList();
}

int day17_part1() {
  var lines = readLines(17, 'data');

  var cubes = parseLines(lines);
  var world = World(cubes);

  for (var i = 0; i < 6; i++) {
    world.cycle();
  }

  return world.cubes.length;
}

int day17_part2() {
  var lines = readLines(17, 'sample');

  return 0;
}
