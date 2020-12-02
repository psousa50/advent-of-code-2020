import 'dart:io';

List<String> readLines(int day, String file) {
  return File('./lib/day${day.toString().padLeft(2, '0')}/$file.txt')
      .readAsLinesSync();
}
