import '../common.dart';

List<int> buildGroupsStep3(List<int> numbers) {
  var groupsStep3 = <int>[1];
  var prev = 0;
  for (var i = 0; i < numbers.length; i++) {
    if (numbers[i] - prev < 3) {
      groupsStep3[groupsStep3.length - 1]++;
    } else {
      groupsStep3.add(1);
    }
    prev = numbers[i];
  }

  return groupsStep3;
}

int day10_part1() {
  var lines = readLines(10, 'data');

  var numbers = lines.map(int.parse).toList()..sort();

  var groups = buildGroupsStep3(numbers);
  var n3 = groups.length;
  var n1 = groups.sum() - groups.length;

  return n1 * n3;
}

int fibonacci3(int value) {
  return value < 1
      ? 0
      : value == 1
          ? 1
          : fibonacci3(value - 3) +
              fibonacci3(value - 2) +
              fibonacci3(value - 1);
}

int day10_part2() {
  var lines = readLines(10, 'data');

  var numbers = lines.map(int.parse).toList()..sort();
  numbers.add(numbers.last + 3);

  return buildGroupsStep3(numbers).map(fibonacci3).product();
}
