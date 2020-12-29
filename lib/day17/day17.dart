import 'package:collection/collection.dart';

import '../common.dart';

Function listEquals = const DeepCollectionEquality().equals;

class HyperCube {
  final List<int> coords;

  HyperCube(this.coords);

  @override
  String toString() {
    return '$coords';
  }

  List<HyperCube> getNeighbours() {
    var neighbours = <HyperCube>[];
    var lowerPoint = this - 1;
    var upperPoint = this + 1;
    var cube = HyperCubeIterator(lowerPoint, upperPoint);
    while (!cube.done) {
      if (cube.currentCube != this) {
        neighbours.add(cube.currentCube.copyWith());
      }
      cube.nextCube();
    }
    return neighbours;
  }

  HyperCube operator +(int value) {
    return HyperCube(coords.map((c) => c + value).toList());
  }

  HyperCube operator -(int value) {
    return HyperCube(coords.map((c) => c - value).toList());
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HyperCube && listEquals(o.coords, coords);
  }

  @override
  int get hashCode => coords.sum();

  HyperCube copyWith({
    List<int> coords,
  }) {
    return HyperCube(
      coords ?? List.from(this.coords),
    );
  }
}

class HyperCubeIterator {
  final HyperCube lowerCube;
  final HyperCube upperCube;
  HyperCube currentCube;
  bool done = false;

  HyperCubeIterator(this.lowerCube, this.upperCube) {
    currentCube = lowerCube.copyWith();
  }

  void nextCube({int pos = 0}) {
    if (pos < currentCube.coords.length) {
      currentCube.coords[pos]++;
      if (currentCube.coords[pos] > upperCube.coords[pos]) {
        currentCube.coords[pos] = lowerCube.coords[pos];
        nextCube(pos: pos + 1);
      }
    } else {
      done = true;
    }
  }
}

class World {
  List<HyperCube> cubes;

  World(this.cubes);

  bool isActive(HyperCube other) {
    return cubes.contains(other);
  }

  Iterable<HyperCube> activeNeighbours(HyperCube cube) {
    return cube.getNeighbours().where(isActive);
  }

  void cycle() {
    var newCubes = <HyperCube>[];
    var inactiveNeighbours = <HyperCube>{};
    for (var cube in cubes) {
      var activeNeighboursCount = 0;
      for (var neighbour in cube.getNeighbours()) {
        if (isActive(neighbour)) {
          activeNeighboursCount++;
        } else {
          inactiveNeighbours.add(neighbour);
        }
      }
      if ([2, 3].contains(activeNeighboursCount)) {
        newCubes.add(cube.copyWith());
      }
    }

    for (var cube in inactiveNeighbours) {
      if (activeNeighbours(cube).length == 3) {
        newCubes.add(cube.copyWith());
      }
    }

    cubes = newCubes;
  }

  @override
  String toString() {
    return '$cubes';
  }
}

List<HyperCube> parseLines(List<String> lines, int dimensions) {
  var cubes = <HyperCube>[];

  for (var y = 0; y < lines.length; y++) {
    cubes.addAll(
      lines[y].split('').mapIndexed((a, x) =>
          a == '#' ? HyperCube([x, y, 0, 0].sublist(0, dimensions)) : null),
    );
  }

  return cubes.where((c) => c != null).toList();
}

int day17_part1() {
  var lines = readLines(17, 'data');

  var cubes = parseLines(lines, 3);
  var world = World(cubes);

  for (var i = 0; i < 6; i++) {
    world.cycle();
  }

  return world.cubes.length;
}

int day17_part2() {
  var lines = readLines(17, 'data');

  var cubes = parseLines(lines, 4);
  var world = World(cubes);

  for (var i = 0; i < 6; i++) {
    world.cycle();
  }

  return world.cubes.length;
}
