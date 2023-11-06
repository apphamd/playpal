import 'package:flutter/material.dart';
import 'package:playpal/crud/enum/enum.dart' hide EnergyLevel;
import 'package:playpal/models/dog_model.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({
    super.key,
    required this.test,
    required this.energyLevelsDropdownController,
    required this.weightComparisonDropdownController,
    required this.weightTextController,
    required this.ageComparisonDropdownController,
    required this.ageTextController,
  });
  final Function test;
  final TextEditingController energyLevelsDropdownController;
  final TextEditingController weightComparisonDropdownController;
  final TextEditingController weightTextController;
  final TextEditingController ageComparisonDropdownController;
  final TextEditingController ageTextController;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<EnergyLevel>> energyLevelEntries =
        <DropdownMenuEntry<EnergyLevel>>[];
    for (final EnergyLevel energy in EnergyLevel.values) {
      energyLevelEntries.add(
        DropdownMenuEntry<EnergyLevel>(value: energy, label: energy.level),
      );
    }

    final List<DropdownMenuEntry<Location>> locationEntries =
        <DropdownMenuEntry<Location>>[];
    for (final Location location in Location.values) {
      locationEntries.add(
        DropdownMenuEntry<Location>(value: location, label: location.city),
      );
    }

    final List<DropdownMenuEntry<Comparison>> comparisonEntries =
        <DropdownMenuEntry<Comparison>>[];
    for (final Comparison comparison in Comparison.values) {
      comparisonEntries.add(
        DropdownMenuEntry<Comparison>(
            value: comparison, label: comparison.symbol),
      );
    }

    return IconButton(
        icon: const Icon(Icons.filter_alt, size: 30.0),
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Filter'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                // Energy Levels
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Energy Level: '),
                    DropdownMenu<EnergyLevel>(
                      initialSelection: EnergyLevel.all,
                      controller: widget.energyLevelsDropdownController,
                      dropdownMenuEntries: energyLevelEntries,
                    )
                  ],
                ),

                // weight
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Weight: '),
                    DropdownMenu(
                      width: 100,
                      controller: widget.weightComparisonDropdownController,
                      dropdownMenuEntries: comparisonEntries,
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: widget.weightTextController,
                        showCursor: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),

                // age
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Age: '),
                    DropdownMenu(
                      width: 100,
                      controller: widget.ageComparisonDropdownController,
                      dropdownMenuEntries: comparisonEntries,
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: widget.ageTextController,
                        showCursor: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    widget.test();
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
  }
}
