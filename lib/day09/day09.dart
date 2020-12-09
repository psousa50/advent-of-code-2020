import '../common.dart';

List<List<int>> calculatePairsSum(List<int> numbers, int preamble) {
  var pairsSum = <List<int>>[];

  for (var c1 = 0; c1 < preamble - 1; c1++) {
    pairsSum.add([]);
    for (var c2 = c1 + 1; c2 < preamble; c2++) {
      pairsSum[c1].add(numbers[c1] + numbers[c2]);
    }
  }

  return pairsSum;
}

int incorrectNumber(List<int> numbers, int preamble) {
  var pairsSum = calculatePairsSum(numbers, preamble);

  var found;
  for (var c = preamble; c < numbers.length; c++) {
    if (!pairsSum.expand((e) => e).contains(numbers[c])) {
      found = numbers[c];
      break;
    }
    pairsSum = pairsSum.sublist(1)..add([]);
    for (var p = 0; p < preamble - 1; p++) {
      pairsSum[p].add(numbers[c - preamble + p + 1] + numbers[c]);
    }
  }

  return found;
}

int incorrectNumberRecursive(List<int> numbers, int preamble) {
  List<List<int>> updatePairsSum(int pos, List<List<int>> pairsSum) {
    pairsSum = pairsSum.sublist(1)..add([]);
    for (var p = 0; p < preamble - 1; p++) {
      pairsSum[p].add(numbers[pos - preamble + p + 1] + numbers[pos]);
    }
    return pairsSum;
  }

  int find(int pos, List<List<int>> pairsSum) {
    return pairsSum.expand((e) => e).contains(numbers[pos])
        ? find(pos + 1, updatePairsSum(pos, pairsSum))
        : numbers[pos];
  }

  var pairsSum = calculatePairsSum(numbers, preamble);
  return find(preamble, pairsSum);
}

int day09_part1() {
  var lines = readLines(9, 'data');

  var numbers = lines.map(int.parse).toList();

  return incorrectNumberRecursive(numbers, 25);
}

int findNumbersThatSumUpTo(List<int> numbers, int requestedSum) {
  var start = 0;
  var sum = 0;
  var c = 0;
  while (sum != requestedSum && c < numbers.length) {
    sum += numbers[c];
    while (sum > requestedSum) {
      sum -= numbers[start];
      start++;
    }
    c++;
  }

  var end = c;
  var sequence = numbers.sublist(start, end)..sort();

  return sequence.first + sequence.last;
}

int day09_part2() {
  var lines = readLines(9, 'data');

  var numbers = lines.map(int.parse).toList();

  return findNumbersThatSumUpTo(numbers, 22477624);
}
