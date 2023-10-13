enum EnergyLevel {
  high('high', 3),
  medium('medium', 2),
  low('low', 1),
  all('all', 0);

  const EnergyLevel(this.level, this.value);
  final String level;
  final int value;
}

enum Location {
  oxford('Oxford', 'MS'),
  oceanSprings('Ocean Springs', 'MS'),
  jackson('Jackson', 'MS'),
  dallas('Dallas', 'TX'),
  all('all', 'all');

  const Location(this.city, this.state);
  final String city;
  final String state;
}

enum Comparison {
  lessThan('<'),
  lessThanOrEqualTo('≤'),
  equalTo('='),
  greaterThanOrEqualTo('≥'),
  greaterThan('>'),
  all('all');

  const Comparison(this.symbol);
  final String symbol;
}
