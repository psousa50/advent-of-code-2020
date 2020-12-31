import '../common.dart';

class Stack<T> {
  List<T> values = [];

  int get length => values.length;

  bool get isEmpty => values.isEmpty;

  void push(T value) {
    if (value != null) values.add(value);
  }

  T peek([int pos = 0]) {
    return values[values.length - 1 - pos];
  }

  T pop() {
    if (values.isNotEmpty) {
      var value = values.last;
      values = values.sublist(0, values.length - 1);
      return value;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return '$values';
  }
}

class Expression {
  final List<String> tokens;
  final Map<String, int> precedences;

  int pos = 0;
  var operands = Stack<int>();
  var operations = Stack<String>();

  Expression(this.tokens, this.precedences);

  String fetchToken() {
    return (pos >= tokens.length) ? null : tokens[pos++];
  }

  int fetchOperand() {
    var token = fetchToken();
    if (token == '(') {
      var e = Expression(tokens.sublist(pos), precedences);
      var operand = e.value();
      pos = pos + e.pos;
      return operand;
    } else {
      return token != null ? int.parse(token) : null;
    }
  }

  void performOperation() {
    var op2 = operands.pop();
    var op1 = operands.pop();
    var operation = operations.pop();
    var result = operation == '*' ? op1 * op2 : op1 + op2;
    operands.push(result);
  }

  void calculate() {
    if (operations.length >= 2) {
      var lastOperation = operations.pop();
      var prevOperation = operations.peek();
      if (precedences[prevOperation] >= precedences[lastOperation]) {
        performOperation();
      }
      operations.push(lastOperation);
    }
  }

  int value() {
    String token;
    do {
      operands.push(fetchOperand());
      token = fetchToken();
      if (['+', '*'].contains(token)) {
        operations.push(token);
      }
      calculate();
    } while (token != null && token != ')');
    while (!operations.isEmpty) {
      performOperation();
    }
    return operands.pop();
  }
}

Iterable<Expression> parseLines(
    List<String> lines, Map<String, int> precendences) {
  return lines.map((line) {
    var tokens = RegExp(r'\s*([0-9]|.)\s*')
        .allMatches(line)
        .map((t) => t.group(0).trim())
        .toList();
    return Expression(tokens, precendences);
  });
}

int day18_part1() {
  var lines = readLines(18, 'data');

  var precedences = {'*': 0, '+': 0};
  var expressions = parseLines(lines, precedences);

  var values = expressions.map((e) => e.value());

  return values.sum();
}

int day18_part2() {
  var lines = readLines(18, 'data');

  var precedences = {'*': 0, '+': 1};
  var expressions = parseLines(lines, precedences);

  var values = expressions.map((e) => e.value());

  return values.sum();
}
