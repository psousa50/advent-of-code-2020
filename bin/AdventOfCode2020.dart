import 'package:AdventOfCode2020/day01/day01.dart';
import 'package:AdventOfCode2020/day02/day02.dart';

const solutions = {
  '1_1': day01_part1,
  '1_2': day01_part2,
  '2_1': day02_part1,
  '2_2': day02_part2,
};

void main(List<String> arguments) {
  var day = arguments[0];
  print(solutions[day]());
}
