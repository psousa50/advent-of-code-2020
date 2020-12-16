import 'package:AdventOfCode2020/day01/day01.dart';
import 'package:AdventOfCode2020/day02/day02.dart';
import 'package:AdventOfCode2020/day03/day03.dart';
import 'package:AdventOfCode2020/day04/day04.dart';
import 'package:AdventOfCode2020/day05/day05.dart';
import 'package:AdventOfCode2020/day06/day06.dart';
import 'package:AdventOfCode2020/day07/day07.dart';
import 'package:AdventOfCode2020/day08/day08.dart';
import 'package:AdventOfCode2020/day09/day09.dart';
import 'package:AdventOfCode2020/day10/day10.dart';
import 'package:AdventOfCode2020/day11/day11.dart';
import 'package:AdventOfCode2020/day12/day12.dart';
import 'package:AdventOfCode2020/day13/day13.dart';

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
  '6_1': day06_part1,
  '6_2': day06_part2,
  '7_1': day07_part1,
  '7_2': day07_part2,
  '8_1': day08_part1,
  '8_2': day08_part2,
  '9_1': day09_part1,
  '9_2': day09_part2,
  '10_1': day10_part1,
  '10_2': day10_part2,
  '11_1': day11_part1,
  '11_2': day11_part2,
  '12_1': day12_part1,
  '12_2': day12_part2,
  '13_1': day13_part1,
  '13_2': day13_part2,
};

void main(List<String> arguments) {
  var day = arguments[0];

  final stopwatch = Stopwatch()..start();
  var solution = solutions[day]();
  print('Time elapsed: ${stopwatch.elapsed.inMilliseconds} \n');
  print(solution);
}
