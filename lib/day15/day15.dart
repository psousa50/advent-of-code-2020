import '../common.dart';

int day15_part1() {
  var lines = readLines(15, 'data');

  var numbers = lines[0].split(',').map(int.parse).toList();

  var counts = <int, List<int>>{};

  int lastNumber;
  for (var i = 0; i < 2020; i++) {
    int number;
    if (i < numbers.length) {
      number = numbers[i];
    } else {
      var c = counts[lastNumber];
      number = c == null || c.length == 1 ? 0 : c[1] - c[0];
    }
    lastNumber = number;
    var c = (counts[lastNumber] ?? []).length;
    if (c == 0) {
      counts[lastNumber] = [i];
    }
    if (c == 1) {
      counts[lastNumber] = [counts[lastNumber][0], i];
    }
    if (c == 2) {
      counts[lastNumber] = [counts[lastNumber][1], i];
    }
  }

  return lastNumber;
}

int day15_part2() {
  var lines = readLines(15, 'sample');

  return 0;
}
