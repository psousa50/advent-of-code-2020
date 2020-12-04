import '../common.dart';

enum FieldName {
  byr,
  iyr,
  eyr,
  hgt,
  hcl,
  ecl,
  pid,
  cid,
}

class Passport {
  final Map<FieldName, String> fields;

  Passport(this.fields);

  void addField(FieldName name, String value) {
    fields[name] = value;
  }

  @override
  String toString() {
    return fields.toString();
  }
}

void addFields(Passport passport, String line) {
  var fields = line.split(' ');
  fields.forEach((field) {
    var f = field.split(':');
    passport.addField(
        FieldName.values.firstWhere((e) => e.toString() == 'FieldName.${f[0]}'),
        f[1]);
  });
}

bool validPassportPart1(Passport passport) {
  var mandatoryFields = [
    FieldName.byr,
    FieldName.iyr,
    FieldName.eyr,
    FieldName.hgt,
    FieldName.hcl,
    FieldName.ecl,
    FieldName.pid,
  ];

  var count = passport.fields.keys
      .where((element) => mandatoryFields.contains(element))
      .length;

  return count == mandatoryFields.length;
}

List<Passport> parseLines(List<String> lines) {
  var passports = <Passport>[];
  Passport passport;

  lines.forEach((line) {
    if (line.isEmpty) {
      passport = null;
    } else {
      if (passport == null) {
        passport = Passport({});
        passports.add(passport);
      }
      addFields(passport, line);
    }
  });

  return passports;
}

bool validYear(String value, int min, int max) {
  var year = int.tryParse(value);

  return year != null && year >= min && year <= max;
}

bool height(String value) {
  var i = value.indexOf(RegExp('[a-z]'));
  if (i < 0) return false;

  var height = int.tryParse(value.substring(0, i));
  var measure = value.substring(i);

  return height != null &&
      ((measure == 'cm' && height >= 150 && height <= 193) ||
          (measure == 'in' && height >= 59 && height <= 76));
}

bool hairColor(String value) {
  return value.length == 7 && (RegExp('#[0-9a-f]{6}').hasMatch(value));
}

bool eyeColor(String value) {
  return ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].contains(value);
}

bool passportId(String value) {
  return value.length == 9 && (RegExp('[0-9]{9}').hasMatch(value));
}

typedef FieldValidation = bool Function(String value);

bool byrValidation(String value) => validYear(value, 1920, 2002);
bool iyrValidation(String value) => validYear(value, 2010, 2020);
bool eyrValidation(String value) => validYear(value, 2020, 2030);
bool hgtValidation(String value) => height(value);
bool hclValidation(String value) => hairColor(value);
bool eclValidation(String value) => eyeColor(value);
bool pidValidation(String value) => passportId(value);
bool cidValidation(String value) => true;

var fieldIsValid = {
  FieldName.byr: byrValidation,
  FieldName.iyr: iyrValidation,
  FieldName.eyr: eyrValidation,
  FieldName.hgt: hgtValidation,
  FieldName.hcl: hclValidation,
  FieldName.ecl: eclValidation,
  FieldName.pid: pidValidation,
  FieldName.cid: cidValidation,
};

bool validPassportPart2(Passport passport) {
  if (!validPassportPart1(passport)) {
    return false;
  }

  return passport.fields.entries.fold(
      true, (valid, field) => valid && fieldIsValid[field.key](field.value));
}

int day04_part1() {
  var lines = readLines(4, 'data');

  var passports = parseLines(lines);

  return passports.where(validPassportPart1).length;
}

int day04_part2() {
  var lines = readLines(4, 'data');

  var passports = parseLines(lines);

  return passports.where(validPassportPart2).length;
}
