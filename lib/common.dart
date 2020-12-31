import 'dart:io';

List<String> readLines(int day, String file) {
  return File('./lib/day${day.toString().padLeft(2, '0')}/$file.txt')
      .readAsLinesSync();
}

extension Iterables<T> on Iterable<T> {
  num sumBy(num Function(T element) f) {
    return fold(0, (total, item) => total + f(item));
  }

  num sum() {
    return fold(0, (total, item) => total + (item as num));
  }

  num product() {
    return fold(1, (total, item) => total * (item as num));
  }
}

extension Lists<T> on List<T> {
  void replaceAt(int index, T element) {
    removeAt(index);
    insert(index, element);
  }

  List<T> shallowCopy() {
    return List.from(this);
  }

  List<K> mapIndexed<K>(K Function(T element, int i) f) {
    return asMap().entries.map((e) => f(e.value, e.key)).toList();
  }
}

T enumFromString<T>(List<T> values, String value, {T defaultValue}) {
  return values.firstWhere((v) => v.toString().split('.')[1] == value,
      orElse: () => null);
}

extension IntUtils on String {
  int toInt() => this == null ? null : int.parse(this);
}
