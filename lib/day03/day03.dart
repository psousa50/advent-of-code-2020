import '../common.dart';

int countTrees(List<String> treeMap, int stepX, int stepY) {
  var y = 0;
  var x = 0;
  var treeCount = 0;

  while (y < treeMap.length) {
    var isTree = treeMap[y][x] == '#';
    treeCount = treeCount + (isTree ? 1 : 0);
    x = (x + stepX) % treeMap[0].length;
    y = y + stepY;
  }

  return treeCount;
}

int day03_part1() {
  var lines = readLines(3, 'data');

  return countTrees(lines, 3, 1);
}

int day03_part2() {
  var lines = readLines(3, 'data');

  var allSteps = [
    [1, 1],
    [3, 1],
    [5, 1],
    [7, 1],
    [1, 2],
  ];

  var treeCounts =
      allSteps.map((steps) => countTrees(lines, steps[0], steps[1]));

  return treeCounts.fold(1, (product, treeCount) => product * treeCount);
}
