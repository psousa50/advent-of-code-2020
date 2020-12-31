import '../common.dart';

typedef BinaryOperation = int Function(int, int);

class Operation {
  final String symbol;
  final int precedence;
  final BinaryOperation f;

  Operation(this.symbol, this.precedence, this.f);
  int execute(int v1, int v2) => f(v1, v2);
}

class Operations {
  final Map<String, Operation> operations;

  Operations(Iterable<Operation> ops)
      : operations = ops.fold(<String, Operation>{}, (t, o) {
          t[o.symbol] = o;
          return t;
        });

  Operation operator [](String symbol) => operations[symbol];

  bool isOperation(String symbol) => operations.keys.contains(symbol);
}

class Stack<T> {
  List<T> values = [];

  int get length => values.length;
  bool get isEmpty => values.isEmpty;

  void push(T value) {
    if (value != null) values.add(value);
  }

  T peek() {
    return values.last;
  }

  T pop() {
    return values.removeLast();
  }

  @override
  String toString() {
    return '$values';
  }
}

class Expression {
  final List<String> tokens;
  final Operations operations;

  int tokensCursor = 0;
  var operandsStack = Stack<int>();
  var operationsStack = Stack<Operation>();

  Expression(this.tokens, this.operations);

  String fetchToken() {
    return (tokensCursor >= tokens.length) ? null : tokens[tokensCursor++];
  }

  int fetchOperand() {
    var token = fetchToken();
    if (token == '(') {
      var e = Expression(tokens.sublist(tokensCursor), operations);
      var operand = e.value();
      tokensCursor = tokensCursor + e.tokensCursor;
      return operand;
    } else {
      return token.toInt();
    }
  }

  void performLastOperation() {
    var op1 = operandsStack.pop();
    var op2 = operandsStack.pop();
    var operation = operationsStack.pop();
    var result = operation.execute(op1, op2);
    operandsStack.push(result);
  }

  void calculateIfPrecedenceAllow() {
    if (operationsStack.length >= 2) {
      var lastOperation = operationsStack.pop();
      var prevOperation = operationsStack.peek();
      if (prevOperation.precedence >= lastOperation.precedence) {
        performLastOperation();
      }
      operationsStack.push(lastOperation);
    }
  }

  bool parsing() {
    operandsStack.push(fetchOperand());
    var token = fetchToken();
    if (operations.isOperation(token)) {
      operationsStack.push(operations[token]);
    }
    return token != null && token != ')';
  }

  int performRemainingOperations() {
    while (!operationsStack.isEmpty) {
      performLastOperation();
    }
    return operandsStack.pop();
  }

  int value() {
    while (parsing()) {
      calculateIfPrecedenceAllow();
    }

    return performRemainingOperations();
  }
}

Iterable<Expression> parseLines(List<String> lines, Operations precendences) {
  return lines.map((line) {
    var tokens = RegExp(r'\s*([0-9]|.)\s*')
        .allMatches(line)
        .map((t) => t.group(0).trim())
        .toList();
    return Expression(tokens, precendences);
  });
}

int sum(int v1, int v2) => v1 + v2;
int product(int v1, int v2) => v1 * v2;

int day18_part1() {
  var lines = readLines(18, 'data');

  var operations = Operations([
    Operation('*', 0, product),
    Operation('+', 0, sum),
  ]);
  var expressions = parseLines(lines, operations);

  var values = expressions.map((e) => e.value());

  return values.sum();
}

int day18_part2() {
  var lines = readLines(18, 'data');

  var operations = Operations([
    Operation('*', 0, product),
    Operation('+', 1, sum),
  ]);
  var expressions = parseLines(lines, operations);

  var values = expressions.map((e) => e.value());

  return values.sum();
}
