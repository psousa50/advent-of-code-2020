import '../common.dart';

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);

  Point add(Point p) {
    return Point(x + p.x, y + p.y);
  }

  @override
  String toString() {
    return '($x,$y)';
  }
}

var neighbours = [
  Point(-1, -1),
  Point(0, -1),
  Point(1, -1),
  Point(-1, 0),
  Point(1, 0),
  Point(-1, 1),
  Point(0, 1),
  Point(1, 1),
];

enum Place {
  occupied,
  empty,
  floor,
  out,
}

const placeToSymbol = {
  '#': Place.occupied,
  'L': Place.empty,
  '.': Place.floor,
};

const symbolToPlace = {
  Place.occupied: '#',
  Place.empty: 'L',
  Place.floor: '.',
};

typedef CountOccupied = int Function(Point p);

class Seats {
  final List<List<Place>> lines;

  Seats(this.lines);

  static Seats iteration(
      Seats seats, CountOccupied countOccupied, int maxNeighbours) {
    var lines = seats.lines.map((line) => List<Place>.from(line)).toList();
    for (var y = 0; y < seats.lines.length; y++) {
      for (var x = 0; x < seats.lines[y].length; x++) {
        var p = Point(x, y);
        var adjacent = countOccupied(p);
        if (seats.place(p) == Place.empty && adjacent == 0) {
          lines[y][x] = Place.occupied;
        }
        if (seats.place(p) == Place.occupied && adjacent >= maxNeighbours) {
          lines[y][x] = Place.empty;
        }
      }
    }
    return Seats(lines);
  }

  factory Seats.iterationAdjacent(Seats seats) {
    return iteration(seats, seats.adjacentOcuppiedCount, 4);
  }

  factory Seats.iterationFirstSeen(Seats seats) {
    return iteration(seats, seats.firstSeenOcuppiedCount, 5);
  }

  String toSymbol(Place p) => symbolToPlace[p];

  Place place(Point p) =>
      p.y >= 0 && p.y < lines.length && p.x >= 0 && p.x < lines[0].length
          ? lines[p.y][p.x]
          : Place.out;

  Iterable<Place> places(Iterable<Point> points) {
    return points.map(place);
  }

  int adjacentOcuppiedCount(Point p) {
    return (neighbours.map(p.add))
        .map(place)
        .where((p) => p == Place.occupied)
        .length;
  }

  int firstSeenOcuppiedCount(Point p) {
    var findNonEmpty = (Point direction) {
      var p1 = p;
      do {
        p1 = p1.add(direction);
      } while (place(p1) == Place.floor);

      return place(p1);
    };

    return neighbours
        .map(findNonEmpty)
        .where((p) => p == Place.occupied)
        .length;
  }

  int occupiedCount() {
    return lines
        .map((line) => line.where((p) => p == Place.occupied).length)
        .sum();
  }

  @override
  String toString() {
    return lines.map((line) => line.map(toSymbol).join('')).join('\n');
  }
}

Seats iterateAdjacent(Seats seats) {
  var newSeats = Seats.iterationAdjacent(seats);
  return newSeats.toString() == seats.toString()
      ? seats
      : iterateAdjacent(newSeats);
}

int day11_part1() {
  var lines = readLines(11, 'data');

  var seats = Seats(lines
      .map((line) => line.split('').map((p) => placeToSymbol[p]).toList())
      .toList());

  var newSeats = iterateAdjacent(seats);

  return newSeats.occupiedCount();
}

Seats iterateFirstSeen(Seats seats) {
  var newSeats = Seats.iterationFirstSeen(seats);
  return newSeats.toString() == seats.toString()
      ? seats
      : iterateFirstSeen(newSeats);
}

int day11_part2() {
  var lines = readLines(11, 'data');

  var seats = Seats(lines
      .map((line) => line.split('').map((p) => placeToSymbol[p]).toList())
      .toList());

  var newSeats = iterateFirstSeen(seats);

  return newSeats.occupiedCount();
}
