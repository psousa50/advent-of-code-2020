import '../common.dart';

class ModifyProgramResult {
  final List<Instruction> program;
  final int indexOfInstructionToModify;
  ModifyProgramResult(
    this.program,
    this.indexOfInstructionToModify,
  );
}

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

  bool runUntilRepeatedInstruction(List<Instruction> program) {
    var visited = <int>[];
    accumulator = 0;
    pc = 0;
    while (!visited.contains(pc) && pc < program.length) {
      visited.add(pc);
      var instruction = program[pc];
      pc += 1;
      execute[instruction.operation](instruction.argument);
    }

    return pc < program.length;
  }

  int nextModifiableInstructionIndex(List<Instruction> program, int startAt) {
    return program.indexWhere(
        (i) => [Operation.jmp, Operation.nop].contains(i.operation), startAt);
  }

  ModifyProgramResult modifyProgram(
    List<Instruction> program,
    int indexOfInstructionToModify,
  ) {
    indexOfInstructionToModify = program.indexWhere(
      (i) => [Operation.jmp, Operation.nop].contains(i.operation),
      indexOfInstructionToModify,
    );

    var instruction = program[indexOfInstructionToModify];
    var modifiedInstruction = Instruction(
      instruction.operation == Operation.jmp ? Operation.nop : Operation.jmp,
      instruction.argument,
    );

    var modifiedProgram = program.shallowCopy()
      ..replaceAt(indexOfInstructionToModify, modifiedInstruction);

    return ModifyProgramResult(
      modifiedProgram,
      indexOfInstructionToModify + 1,
    );
  }

  void fixCorruptedInstruction(List<Instruction> program) {
    var indexOfInstructionToModify = 0;
    var done = false;
    while (!done) {
      var modified = modifyProgram(program, indexOfInstructionToModify);
      indexOfInstructionToModify = modified.indexOfInstructionToModify;
      done = !runUntilRepeatedInstruction(modified.program);
    }
  }
}

Instruction parseInstruction(String line) {
  var parts = line.split(' ');
  var operation = enumFromString(Operation.values, parts[0]);
  var argument = int.parse(parts[1]);
  return Instruction(operation, argument);
}

List<Instruction> parseProgram(List<String> lines) {
  return lines.map(parseInstruction).toList();
}

int day08_part1() {
  var lines = readLines(8, 'data');

  var program = parseProgram(lines);

  var cpu = Cpu()..runUntilRepeatedInstruction(program);

  return cpu.accumulator;
}

int day08_part2() {
  var lines = readLines(8, 'data');

  var program = parseProgram(lines);

  var cpu = Cpu()..fixCorruptedInstruction(program);

  return cpu.accumulator;
}
