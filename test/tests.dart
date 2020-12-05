import 'package:AdventOfCode2020/day01/day01.dart';
import 'package:AdventOfCode2020/day02/day02.dart';
import 'package:AdventOfCode2020/day03/day03.dart';
import 'package:AdventOfCode2020/day04/day04.dart';
import 'package:AdventOfCode2020/day05/day05.dart';
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
      expect(day02_part1(), 546);
    });
    test('part 2', () {
      expect(day02_part2(), 275);
    });
  });

  group('day 03', () {
    test('part 1', () {
      expect(day03_part1(), 240);
    });
    test('part 2', () {
      expect(day03_part2(), 2832009600);
    });
  });

  group('day 04', () {
    test('part 1', () {
      expect(day04_part1(), 256);
    });
    test('part 2', () {
      expect(day04_part2(), 198);
    });
  });
  group('day 05', () {
    test('part 1', () {
      expect(day05_part1(), 855);
    });
    test('part 2', () {
      expect(day05_part2(), 552);
    });
  });
}
