import '../common.dart';

class Seat {
  final int row;
  final int column;
  final int seatId;

  Seat({
    this.row,
    this.column,
  }) : seatId = row * 8 + column;
}

class Option<T> {
  final T _value;
  Option(this._value);

  factory Option.some(T value) => Option(value);
  factory Option.none() => Option(null);

  T get value => _value;
  bool get hasValue => _value != null;
}

typedef Test = bool Function();
typedef Result<T> = T Function();
typedef When<T> = Option<T> Function();

T select<T>(List<When<T>> conditions, {Result<T> elseValue}) {
  T result;
  for (var c in conditions) {
    var r = c();
    if (r.hasValue) {
      result = r.value;
      break;
    }
  }

  return result ?? elseValue();
}

When<T> when<T>(Test test, Result<T> trueValue) {
  var condition = () {
    return test() ? Option.some(trueValue()) : Option<T>.none();
  };
  return condition;
}

int binaryCrawl(
  String code,
  int lower,
  int upper,
  String takeLower,
  String takeUpper,
) {
  var middle = lower + (upper - lower + 1) ~/ 2;

  return select(
    [
      when(
        () => lower == upper,
        () => lower,
      ),
      when(
        () => code[0] == takeLower,
        () => binaryCrawl(
          code.substring(1),
          lower,
          middle - 1,
          takeLower,
          takeUpper,
        ),
      ),
      when(
        () => code[0] == takeUpper,
        () => binaryCrawl(
          code.substring(1),
          middle,
          upper,
          takeLower,
          takeUpper,
        ),
      ),
    ],
  );
}

Seat calculateSeatId(String seatCode) {
  var row = binaryCrawl(seatCode.substring(0, 7), 0, 127, 'F', 'B');
  var column = binaryCrawl(seatCode.substring(7), 0, 7, 'L', 'R');
  return Seat(row: row, column: column);
}

int day05_part1() {
  var lines = readLines(5, 'data');

  var seatIds = lines.map(calculateSeatId).toList();

  seatIds.sort((s1, s2) => s2.seatId.compareTo(s1.seatId));

  return seatIds.first.seatId;
}

int day05_part2() {
  var lines = readLines(5, 'data');

  var seatIds = lines.map(calculateSeatId).toList();

  seatIds.sort((s1, s2) => s1.seatId.compareTo(s2.seatId));

  var i;
  for (i = 1; i < seatIds.length; i++) {
    if (seatIds[i].seatId > seatIds[i - 1].seatId + 1) break;
  }

  return seatIds[i - 1].seatId + 1;
}
