import '../common.dart';

class BagContainers {
  final int maxBags;
  final String bagColor;
  BagContainers({
    this.maxBags,
    this.bagColor,
  });
}

class Bag {
  final String color;
  final List<BagContainers> containers;
  Bag({
    this.color,
    this.containers,
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
      return bag.containers
          .where((rule) =>
              rule.bagColor == bagColor || canHold(getBag(rule.bagColor)))
          .isNotEmpty;
    }

    return bags.where(canHold);
  }

  int totalBagsInsideOf(String bagColor) {
    var bag = getBag(bagColor);
    return bag.containers
        .map((b) => b.maxBags * (1 + totalBagsInsideOf(b.bagColor)))
        .sum();
  }
}

Bag parseBag(String line) {
  var bagAndContainersSplitter = RegExp('([a-z]+ [a-z]+) bags contain(.*)');
  var bagAndContainersMatches = bagAndContainersSplitter.firstMatch(line);

  var bagName = bagAndContainersMatches.group(1);
  var bagContainersList = bagAndContainersMatches.group(2);

  var bagContainersSplitter = RegExp('(\s*([0-9])+ ([a-z ]+) bags?)+');
  var bagContainsMatches = bagContainersSplitter.allMatches(bagContainersList);

  var bagContainers = bagContainsMatches.fold(
    <BagContainers>[],
    (list, m) => list
      ..add(
        BagContainers(
          bagColor: m.group(3),
          maxBags: int.parse(m.group(2)),
        ),
      ),
  );

  return Bag(color: bagName, containers: bagContainers);
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

  return bags.totalBagsInsideOf('shiny gold');
}
