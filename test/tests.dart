import 'package:AdventOfCode2020/day01/day01.dart';
import 'package:AdventOfCode2020/day02/day02.dart';
import 'package:test/test.dart';

void main() {
  group('day 01', () {
    test('part 1', () {
      expect(day01_part1(), 802011);
    });

    test('part 2', () {
      expect(day01_part2(), 248607374);
    });
  });

  group('day 02', () {
    test('part 1', () {
      expect(day02_part1(), 2);
    });
  });
}
