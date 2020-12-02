import '../common.dart';

class Password {
  final int min;
  final int max;
  final String letter;
  final String password;
  Password(
    this.min,
    this.max,
    this.letter,
    this.password,
  );
}

Password parseLine(String line) {
  var s = line.split(' ');
  var range = s[0].split('-');
  var min = int.parse(range[0]);
  var max = int.parse(range[1]);
  var letter = s[1][0];
  var password = s[2];
  return Password(min, max, letter, password);
}

List<Password> parseLines(List<String> lines) {
  return lines.map(parseLine).toList();
}

bool passwordIsValidPart1(Password password) {
  var count = password.letter.allMatches(password.password).length;
  return count >= password.min && count <= password.max;
}

int day02_part1() {
  var lines = readLines(2, 'data');
  var passwords = parseLines(lines);

  return passwords.where(passwordIsValidPart1).length;
}

bool passwordIsValidPart2(Password password) {
  var c1 = password.password[password.min - 1] == password.letter ? 1 : 0;
  var c2 = password.password[password.max - 1] == password.letter ? 1 : 0;
  return c1 + c2 == 1;
}

int day02_part2() {
  var lines = readLines(2, 'data');
  var passwords = parseLines(lines);

  return passwords.where(passwordIsValidPart2).length;
}
