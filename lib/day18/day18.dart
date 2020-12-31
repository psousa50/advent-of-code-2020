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
  final String expression;
  final Map<String, int> precedences;

  int pos = 0;
  var operands = Stack<int>();
  var operations = Stack<String>();

  Expression(this.expression, this.precedences);

  String fetchToken() {
    if (pos >= expression.length) {
      return null;
    }
    var match =
        RegExp(r'^\s*([0-9]+|.)\s*').firstMatch(expression.substring(pos));
    var s = pos;
    pos = match != null ? pos + match.end : expression.length;
    var token = match != null ? expression.substring(s, pos) : null;
    return token.trim();
  }

  int fetchOperand() {
    var token = fetchToken();
    if (token == '(') {
      var e = Expression(expression.substring(pos), precedences);
      var operand = e.value();
      pos = pos + e.pos;
      return operand;
    } else {
      return token != null ? int.parse(token) : null;
    }
  }

  String fetchOperation() {
    return fetchToken();
  }

  void performOperation() {
    var op2 = operands.pop();
    var op1 = operands.pop();
    var operation = operations.pop();
    var result = operation == '*' ? op1 * op2 : op1 + op2;
    print('$op1 $operation $op2');
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
  return lines.map((line) => Expression(line, precendences));
}

int day18_part1() {
  var lines = readLines(18, 'data');

  var expressions = parseLines(
    lines,
    {
      '+': 0,
      '*': 0,
    },
  );

  var values = expressions.map((e) => e.value());

  return values.sum();
}

int day18_part2() {
  var lines = readLines(18, 'data');

  var expressions = parseLines(
    lines,
    {
      '+': 1,
      '*': 0,
    },
  );

  var values = expressions.map((e) => e.value());

  return values.sum();
}
