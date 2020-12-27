import 'dart:io';

void main(List<String> args) {
  var dayArg = args[0];

  var day = dayArg.padLeft(2, '0');
  var dir = 'lib/day${day}';

  Directory(dir).create();

  var code =
      File('lib/day_template.txt').readAsStringSync().replaceAll('{day}', day);
  var f = File('$dir/day$day.dart');
  f.createSync();
  f.writeAsStringSync(code);

  File('$dir/data.txt').create();
  File('$dir/sample.txt').create();
}
