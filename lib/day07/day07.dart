import '../common.dart';

class BagContainRule {
  final int maxCount;
  final String bagColor;
  BagContainRule({
    this.maxCount,
    this.bagColor,
  });
}

class Bag {
  final String color;
  final List<BagContainRule> containRules;
  Bag({
    this.color,
    this.containRules,
  });
}

class Bags {
  final List<Bag> bags;

  Bags(this.bags);

  Bag getBag(String bagColor) {
    return bags.firstWhere((b) => b.color == bagColor);
  }

  Iterable<Bag> thatCanHold(String bagColor) {
    bool canHold(Bag bag) {
      bool isOrCanHold(BagContainRule rule) {
        return rule.bagColor == bagColor || canHold(getBag(rule.bagColor));
      }

      return bag.containRules.where(isOrCanHold).isNotEmpty;
    }

    return bags.where(canHold);
  }

  int totalBags(String bagColor) {
    var bag = getBag(bagColor);
    return bag.containRules.sumBy((b) => b.maxCount) +
        bag.containRules.map((b) => b.maxCount * totalBags(b.bagColor)).sum();
  }
}

Bag parseBag(String line) {
  var bagAndContainsSplitter = RegExp('([a-z]+ [a-z]+) bags contain(.*)');
  var bagAndContainsMatches = bagAndContainsSplitter.firstMatch(line);

  var bagName = bagAndContainsMatches.group(1);
  var bagContains = bagAndContainsMatches.group(2);

  var bagContainsSplitter = RegExp('(\s*([0-9])+ ([a-z ]+) bags?)+');
  var bagContainsMatches = bagContainsSplitter.allMatches(bagContains);

  var bagContainsRules = <BagContainRule>[];

  for (var f in bagContainsMatches) {
    bagContainsRules.add(BagContainRule(
      bagColor: f.group(3),
      maxCount: int.parse(f.group(2)),
    ));
  }

  return Bag(color: bagName, containRules: bagContainsRules);
}

Bags parseBags(List<String> lines) {
  return Bags(lines.map(parseBag).toList());
}

int day07_part1() {
  var lines = readLines(7, 'data');

  var bags = parseBags(lines);

  return bags.thatCanHold('shiny gold').length;
}

int day07_part2() {
  var lines = readLines(7, 'data');

  var bags = parseBags(lines);

  return bags.totalBags('shiny gold');
}
