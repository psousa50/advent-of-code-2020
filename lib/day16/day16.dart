import 'dart:math';

import '../common.dart';

class Interval {
  final int left;
  final int right;

  Interval(this.left, this.right);

  Interval union(Interval other) {
    var newLeft = min(left, other.left);
    var newRight = max(right, other.right);
    return (newRight - newLeft + 1 <=
            right - left + 1 + other.right - other.left + 1)
        ? Interval(newLeft, newRight)
        : null;
  }

  bool contains(int value) {
    return left <= value && value <= right;
  }

  @override
  String toString() {
    return '$left-$right';
  }
}

class FieldType {
  final String name;
  final List<Interval> intervals;
  List<int> fieldIndexes = [];

  FieldType(this.name, this.intervals);

  @override
  String toString() {
    return '$name: ${intervals[0]} or ${intervals[1]} (field: $fieldIndexes)';
  }
}

class Scenario {
  final List<FieldType> fieldTypes;
  final List<int> myTicket;
  final List<List<int>> nearbyTickets;

  Scenario(this.fieldTypes, this.myTicket, this.nearbyTickets);
}

List<FieldType> parseFieldTypes(List<String> rules) {
  var fieldTypes = <FieldType>[];
  var r = RegExp(r'(.*):\s([0-9]+)-([0-9]+) or ([0-9]+)-([0-9]+)');
  rules.forEach((rule) {
    var n = r.firstMatch(rule);
    var name = n.group(1);
    var start1 = int.parse(n.group(2));
    var end1 = int.parse(n.group(3));
    var start2 = int.parse(n.group(4));
    var end2 = int.parse(n.group(5));
    fieldTypes.add(FieldType(name, [
      Interval(start1, end1),
      Interval(start2, end2),
    ]));
  });
  return fieldTypes;
}

bool isValid(int field, Iterable<Interval> intervals) {
  return intervals.any((i) => i.contains(field));
}

Scenario parseLines(List<String> lines) {
  var i1 = lines.indexWhere((line) => line.startsWith('your ticket:'));
  var i2 = lines.indexWhere((line) => line.startsWith('nearby tickets:'));

  var rules = lines.sublist(0, i1 - 1);
  var fieldTypes = parseFieldTypes(rules);

  var myTicket = lines[i1 + 1].split(',').map(int.parse).toList();

  var nearbyTickets = lines
      .sublist(i2 + 1)
      .map((line) => line.split(',').map(int.parse).toList())
      .toList();

  return Scenario(fieldTypes, myTicket, nearbyTickets);
}

Iterable<Interval> mergeIntervals(List<FieldType> fieldTypes) {
  var intervals = fieldTypes.map((f) => f.intervals).expand((i) => i).toList();

  for (var i1 = 0; i1 < intervals.length; i1++) {
    for (var i2 = i1 + 1; i2 < intervals.length; i2++) {
      if (intervals[i1] != null && intervals[i2] != null) {
        var union = intervals[i1].union(intervals[i2]);
        if (union != null) {
          intervals[i2] = union;
          intervals[i1] = null;
        }
      }
    }
  }

  var mergedIntervals = intervals.where((i) => i != null);
  return mergedIntervals;
}

int day16_part1() {
  var lines = readLines(16, 'data');

  var scenario = parseLines(lines);

  var mergedIntervals = mergeIntervals(scenario.fieldTypes);

  var allFields = scenario.nearbyTickets.expand((i) => i).toList();

  return allFields.where((f) => !isValid(f, mergedIntervals)).sum();
}

int day16_part2() {
  var lines = readLines(16, 'data');

  var scenario = parseLines(lines);

  var mergedIntervals = mergeIntervals(scenario.fieldTypes);

  var validTickets = scenario.nearbyTickets
      .where(
          (ticket) => ticket.every((field) => isValid(field, mergedIntervals)))
      .toList();

  var fieldColumns = <List<int>>[];
  for (var c = 0; c < validTickets[0].length; c++) {
    fieldColumns.add(validTickets.map((ticket) => ticket[c]).toList());
  }

  var fieldTypes = scenario.fieldTypes;

  for (var ft = 0; ft < fieldTypes.length; ft++) {
    var intervals = fieldTypes[ft].intervals;
    for (var f = 0; f < fieldTypes.length; f++) {
      if (fieldColumns[f].every((f) => isValid(f, intervals))) {
        fieldTypes[ft].fieldIndexes.add(f);
      }
    }
  }

  fieldTypes.sort(
      (ft1, ft2) => ft1.fieldIndexes.length.compareTo(ft2.fieldIndexes.length));

  for (var ft = fieldTypes.length - 1; ft > 0; ft--) {
    fieldTypes[ft]
        .fieldIndexes
        .removeWhere((f) => fieldTypes[ft - 1].fieldIndexes.contains(f));
  }

  return fieldTypes
      .where((f) => f.name.startsWith('departure'))
      .map((f) => scenario.myTicket[f.fieldIndexes[0]])
      .product();
}
