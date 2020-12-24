import 'package:binary/binary.dart';

import '../common.dart';

class Instruction {
  final int address;
  final int value;

  Instruction(this.address, this.value);

  @override
  String toString() {
    return '[$address] = $value';
  }
}

class InstructionSet {
  final String mask;
  List<Instruction> instructions = [];

  InstructionSet(this.mask);

  @override
  String toString() {
    return '$mask \n${instructions.map((e) => e.toString()).join('\n')}';
  }
}

class Program {
  Map<int, int> memory = {};
  List<InstructionSet> instructionsSets = [];

  void runPart1() {
    for (var instructionSet in instructionsSets) {
      var andMask = instructionSet.mask.replaceAll('X', '1').bits;
      var orMask = instructionSet.mask.replaceAll('X', '0').bits;
      for (var instruction in instructionSet.instructions) {
        var value = instruction.value & andMask | orMask;
        memory[instruction.address] = value;
      }
    }
  }

  String inc(String value, List<int> bitPositions, {int pos = 0}) {
    if (pos >= bitPositions.length) {
      return value;
    }
    var p = bitPositions[pos];
    // print('$bitPositions $pos $p $sp');
    return (value[p] == '0')
        ? value.substring(0, p) + '1' + value.substring(p + 1)
        : inc(
            value.substring(0, p) + '0' + value.substring(p + 1), bitPositions,
            pos: pos + 1);
  }

  void runPart2() {
    for (var instructionSet in instructionsSets) {
      var andMask =
          instructionSet.mask.replaceAll('0', '1').replaceAll('X', '0').bits;
      var orMask = instructionSet.mask.replaceAll('X', '0').bits;
      for (var instruction in instructionSet.instructions) {
        var xPos = instructionSet.mask
            .split('')
            .reversed
            .toList()
            .asMap()
            .entries
            .where((e) => e.value == 'X')
            .map((e) => 35 - e.key)
            .toList();

        var initialAddress = instruction.address & andMask | orMask;
        var floatingStr = '0' * 36;
        do {
          var address = initialAddress | floatingStr.bits;
          memory[address] = instruction.value;
          floatingStr = inc(floatingStr, xPos);
        } while (floatingStr.bits > 0);
      }
    }
  }

  int memorySum() {
    return memory.values.sum();
  }

  @override
  String toString() {
    return '${instructionsSets.map((e) => e.toString()).join('\n')}';
  }
}

Program parseLines(List<String> lines) {
  var program = Program();
  InstructionSet instructionSet;
  for (var line in lines) {
    if (line.startsWith('mask')) {
      var mask = line.split('=')[1].trim();
      instructionSet = InstructionSet(mask);
      program.instructionsSets.add(instructionSet);
    } else {
      var s = RegExp(r'mem\[([0-9]+)\]\s*=\s*([0-9]+)');
      var m = s.firstMatch(line);
      var address = int.parse(m.group(1));
      var value = int.parse(m.group(2));
      var instruction = Instruction(address, value);
      instructionSet.instructions.add(instruction);
    }
  }

  return program;
}

int day14_part1() {
  var lines = readLines(14, 'data');

  var program = parseLines(lines);

  program.runPart1();

  return program.memorySum();
}

int day14_part2() {
  var lines = readLines(14, 'data');

  var program = parseLines(lines);

  program.runPart2();

  return program.memorySum();
}
