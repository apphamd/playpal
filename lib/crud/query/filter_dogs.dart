import 'package:flutter/material.dart';

class FilterDogs {
  static List filterByEnergyLevel(
      TextEditingController selection, List queriedDogs) {
    var showResults = [];

    if (selection.text.toLowerCase() == 'all') {
      showResults = queriedDogs;
    } else {
      for (var dog in queriedDogs) {
        var energyLevel = dog['energy_level'].toString().toLowerCase();
        if (energyLevel.contains(selection.text.toLowerCase())) {
          showResults.add(dog);
        }
      }
    }
    return showResults;
  }

  static List filterByCity(TextEditingController selection, List queriedDogs) {
    var showResults = [];

    if (selection.text.toLowerCase() == 'all' ||
        selection.text.toLowerCase() == '') {
      showResults = queriedDogs;
    } else {
      for (var dog in queriedDogs) {
        var city = dog['city'].toString().toLowerCase();
        if (city.contains(selection.text.toLowerCase())) {
          showResults.add(dog);
        }
      }
    }
    return showResults;
  }

  static List filterByWeight(TextEditingController comparison,
      TextEditingController weightInput, List queriedDogs) {
    var showResults = [];

    var comparisonWeight = int.tryParse(weightInput.text.toString());
    print(comparisonWeight);

    if (comparison.text.toLowerCase() == 'all' ||
        comparison.text.toLowerCase() == '' ||
        comparisonWeight == null) {
      showResults = queriedDogs;
    } else {
      for (var dog in queriedDogs) {
        var weight = dog['weight'];
        switch (comparison.text) {
          case '<':
            if (weight < comparisonWeight) {
              showResults.add(dog);
            }
          case '≤':
            if (weight <= comparisonWeight) {
              showResults.add(dog);
            }
          case '=':
            if (weight == comparisonWeight) {
              showResults.add(dog);
            }
          case '≥':
            if (weight >= comparisonWeight) {
              showResults.add(dog);
            }
          case '>':
            if (weight > comparisonWeight) {
              showResults.add(dog);
            }
        }
      }
    }
    return showResults;
  }
}
