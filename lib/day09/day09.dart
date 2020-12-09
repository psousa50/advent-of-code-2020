import '../common.dart';

List<int> calculatePairsSum(List<int> numbers, int start, int preamble) {
  var pairsSum = <int>[];

  for (var c1 = start; c1 < start + preamble - 1; c1++) {
    for (var c2 = c1 + 1; c2 < start + preamble; c2++) {
      pairsSum.add(numbers[c1] + numbers[c2]);
    }
  }

  return pairsSum;
}

int incorrectNumber(List<int> numbers, int preamble) {
  var found;
  for (var c = preamble; c < numbers.length; c++) {
    var pairsSum = calculatePairsSum(numbers, c - preamble, preamble);
    // print(numbers[c]);
    // print(pairsSum);
    if (!pairsSum.contains(numbers[c])) {
      found = numbers[c];
      break;
    }
    for (var p = 0; p < preamble - 1; p++) {
      pairsSum[p] = pairsSum[p] - numbers[c - preamble + p];
    }
    for (var p = preamble - 1; p < pairsSum.length; p++) {
      pairsSum[p] = pairsSum[p] + numbers[c];
    }
  }

  return found;
}

int day09_part1() {
  var lines = readLines(9, 'data');

  var numbers = lines.map(int.parse).toList();

  return incorrectNumber(numbers, 25);
}

int day09_part2() {
  var lines = readLines(9, 'sample');

  var numbers = lines.map(int.parse).toList();

  return incorrectNumber(numbers, 5);
}

// 1 2 3 4 5

// 12 13 14 15
// 23 24 25
// 34 35
// 45

// 2 3 4 5 6

// 23 24 25 26
// 34 35 36
// 45 46
// 56
