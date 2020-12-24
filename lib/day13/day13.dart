import '../common.dart';

int day13_part1() {
  var lines = readLines(13, 'data');

  var earliest = int.parse(lines[0]);
  var busIds =
      lines[1].split(',').where((s) => s != 'x').map(int.parse).toList();

  var times = busIds.map((id) => id * ((earliest ~/ id) + 1)).toList();
  var sortedTimes = List.from(times);
  sortedTimes.sort();
  var minTime = sortedTimes.first;
  var idIndex = times.indexOf(minTime);

  var busId = busIds[idIndex];
  var waitingTime = minTime - earliest;

  return busId * waitingTime;
}

int day13_part2() {
  var lines = readLines(13, 'data');

  var pairs = lines[1].split(',').asMap().entries.where((e) => e.value != 'x');
  var times = pairs.map((e) => e.key).toList();
  var busIds = pairs.map((e) => int.parse(e.value)).toList();

  var prod = busIds.product();

  var l = times.asMap().entries.map((e) {
    var i = e.key;
    var ppi = (prod ~/ busIds[i]);
    var invi = ppi.modInverse(busIds[i]);
    return -times[i] * ppi * invi;
  });

  return l.sum() % prod;
}
