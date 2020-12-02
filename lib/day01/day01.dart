import '../common.dart';

int day01_part1() {
  var lines = readLines(1, 'data');
  var expenses = lines.map(int.parse).toList()..sort((a, b) => a.compareTo(b));

  int v1;
  int v2;

  final count = expenses.length;
  for (var i1 = 0; i1 < count; i1++) {
    v1 = expenses[i1];
    for (var i2 = count - 1; i2 > i1; i2--) {
      v2 = expenses[i2];
      if (v1 + v2 == 2020) break;
    }
    if (v1 + v2 == 2020) break;
  }

  return v1 * v2;
}

int day01_part2() {
  var lines = readLines(1, 'data');
  var expenses = lines.map(int.parse).toList()..sort((a, b) => a.compareTo(b));

  int v1;
  int v2;
  int v3;

  final count = expenses.length;
  for (var i1 = 0; i1 < count; i1++) {
    v1 = expenses[i1];
    for (var i2 = count - 1; i2 > i1; i2--) {
      v2 = expenses[i2];
      for (var i3 = i2 - 1; i3 > i1; i3--) {
        v3 = expenses[i3];
        if (v1 + v2 + v3 <= 2020) break;
      }
      if (v1 + v2 + v3 == 2020) break;
    }
    if (v1 + v2 + v3 == 2020) break;
  }

  return v1 * v2 * v3;
}
