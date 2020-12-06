import '../common.dart';

class GroupAnswers {
  var answers = <String>[];
  var uniqueAnswers = <String>{};
  Map<String, int> answersCount = {};

  void addAnswer(String answer) {
    answers.add(answer);
    var allAnswers = answer.split('');
    uniqueAnswers.addAll(allAnswers);
    allAnswers.forEach((a) {
      answersCount[a] = (answersCount[a] ?? 0) + 1;
    });
  }

  Iterable<String> allYesAnswers() {
    return answersCount.keys.where((a) => answersCount[a] == answers.length);
  }
}

List<GroupAnswers> parseGroups(List<String> lines) {
  var groupAnswersList = <GroupAnswers>[];
  GroupAnswers groupAnswers;

  for (var line in lines) {
    if (line.isEmpty) {
      groupAnswers = null;
    } else {
      if (groupAnswers == null) {
        groupAnswers = GroupAnswers();
        groupAnswersList.add(groupAnswers);
      }
      groupAnswers.addAnswer(line);
    }
  }

  return groupAnswersList;
}

int day06_part1() {
  var lines = readLines(6, 'data');

  var groupAnswersList = parseGroups(lines);

  return groupAnswersList.fold(
      0, (sum, groupAnswers) => sum + groupAnswers.uniqueAnswers.length);
}

int day06_part2() {
  var lines = readLines(6, 'data');

  var groupAnswersList = parseGroups(lines);

  // groupAnswersList.forEach((g) {
  //   print(g.answers);
  //   print(g.answersCount);
  //   print(g.allYesAnswers());
  //   print('\n');
  // });

  return groupAnswersList.fold(
      0, (sum, groupAnswers) => sum + groupAnswers.allYesAnswers().length);
}
