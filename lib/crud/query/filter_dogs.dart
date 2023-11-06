import 'package:flutter/material.dart';
import 'package:playpal/models/dog_model.dart';

class FilterDogs {
  static List<DogModel> filterByEnergyLevel(
    TextEditingController selection,
    List<DogModel> queriedDogs,
  ) {
    List<DogModel> showResults = [];

    if (selection.text.toLowerCase() == 'all') {
      showResults = queriedDogs;
    } else {
      for (var dog in queriedDogs) {
        var energyLevel = dog.energyLevel.toString().toLowerCase();
        if (energyLevel.contains(selection.text.toLowerCase())) {
          showResults.add(dog);
        }
      }
    }

    return showResults;
  }

  static List<DogModel> filterByCity(
      TextEditingController selection, List<DogModel> queriedDogs) {
    List<DogModel> showResults = [];

    if (selection.text.toLowerCase() == 'all' ||
        selection.text.toLowerCase() == '') {
      showResults = queriedDogs;
    } else {
      for (var dog in queriedDogs) {
        var city = dog.city.toString().toLowerCase();
        if (city.contains(selection.text.toLowerCase())) {
          showResults.add(dog);
        }
      }
    }
    return showResults;
  }

  static List<DogModel> filterByWeight(TextEditingController comparison,
      TextEditingController weightInput, List<DogModel> queriedDogs) {
    List<DogModel> showResults = [];

    var comparisonWeight = int.tryParse(weightInput.text.toString());
    print(comparisonWeight);

    if (comparison.text.toLowerCase() == 'all' ||
        comparison.text.toLowerCase() == '' ||
        comparisonWeight == null) {
      showResults = queriedDogs;
    } else {
      for (var dog in queriedDogs) {
        int weight = dog.weight;
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

  static List<DogModel> filterByAge(TextEditingController comparison,
      TextEditingController ageInput, List<DogModel> queriedDogs) {
    List<DogModel> showResults = [];

    var comparisonWeight = int.tryParse(ageInput.text.toString());
    print(comparisonWeight);

    if (comparison.text.toLowerCase() == 'all' ||
        comparison.text.toLowerCase() == '' ||
        comparisonWeight == null) {
      showResults = queriedDogs;
    } else {
      for (var dog in queriedDogs) {
        int weight = dog.age;
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
