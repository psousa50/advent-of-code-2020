import 'package:AdventOfCode2020/day01/day01.dart';
import 'package:AdventOfCode2020/day02/day02.dart';
import 'package:AdventOfCode2020/day03/day03.dart';
import 'package:AdventOfCode2020/day04/day04.dart';
import 'package:AdventOfCode2020/day05/day05.dart';

const solutions = {
  '1_1': day01_part1,
  '1_2': day01_part2,
  '2_1': day02_part1,
  '2_2': day02_part2,
  '3_1': day03_part1,
  '3_2': day03_part2,
  '4_1': day04_part1,
  '4_2': day04_part2,
  '5_1': day05_part1,
  '5_2': day05_part2,
};

void main(List<String> arguments) {
  var day = arguments[0];
  print(solutions[day]());
}
