import '../common.dart';

enum Operation {
  acc,
  jmp,
  nop,
}

class Instruction {
  final Operation operation;
  final int argument;

  Instruction(this.operation, this.argument);

  @override
  String toString() {
    return '${operation} ${argument}';
  }
}

class Cpu {
  int accumulator = 0;
  int pc = 0;
  var visited = <int>[];
  Map<Operation, Function> execute;

  void acc(int argument) {
    accumulator += argument;
  }

  void jmp(int argument) {
    pc += argument - 1;
  }

  Cpu() {
    execute = {
      Operation.acc: acc,
      Operation.jmp: jmp,
      Operation.nop: (_) {},
    };
  }

  void run(List<Instruction> program) {
    while (!visited.contains(pc)) {
      visited.add(pc);
      var instruction = program[pc];
      pc += 1;
      execute[instruction.operation](instruction.argument);
    }
  }
}

Instruction parseInstruction(String line) {
  var s = line.split(' ');
  var operation =
      Operation.values.firstWhere((o) => o.toString() == 'Operation.${s[0]}');
  var argument = int.parse(s[1]);
  return Instruction(operation, argument);
}

List<Instruction> parseProgram(List<String> lines) {
  return lines.map(parseInstruction).toList();
}

int day08_part1() {
  var lines = readLines(8, 'data');

  var program = parseProgram(lines);

  var cpu = Cpu();
  cpu.run(program);

  return cpu.accumulator;
}

int day08_part2() {
  var lines = readLines(8, 'sample');

  return 0;
}
