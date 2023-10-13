import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/crud/enum/enum.dart';
import 'package:playpal/crud/query/filter_dogs.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  final db = FirebaseFirestore.instance.collection('dogs');

  List _allDogs = [];
  List _queriedDogs = [];

  // these text editing controllers listen to input changes from
  // the dropdown menu or a TextField component
  // in order for them to work, add a listener
  // the listener will
  // these must be disposed afterwards
  final TextEditingController _energyLevelsDropdownController =
      TextEditingController();
  final TextEditingController _locationDropdownController =
      TextEditingController();
  final TextEditingController _comparisonDropdownController =
      TextEditingController();
  final TextEditingController _weightTextController = TextEditingController();

  getAllDogs() async {
    List allDogs = [];
    await db.get().then((snapshot) {
      for (var document in snapshot.docs) {
        allDogs.add(document.data());
      }
    });
    setState(() {
      _allDogs = allDogs;
      _queriedDogs = allDogs;
    });
    filterResults(
      _energyLevelsDropdownController,
      _locationDropdownController,
      _comparisonDropdownController,
      _weightTextController,
    );
  }

  onSelectionChange() {
    setState(() {
      _queriedDogs = _allDogs;
    });
    filterResults(
      _energyLevelsDropdownController,
      _locationDropdownController,
      _comparisonDropdownController,
      _weightTextController,
    );
  }

  void filterResults(
    TextEditingController energyLevel,
    TextEditingController city,
    TextEditingController comparison,
    TextEditingController weight,
  ) {
    setState(() {
      _queriedDogs = FilterDogs.filterByEnergyLevel(energyLevel, _queriedDogs);
      _queriedDogs = FilterDogs.filterByCity(city, _queriedDogs);
      _queriedDogs =
          FilterDogs.filterByWeight(comparison, weight, _queriedDogs);
    });
  }

  @override
  void initState() {
    getAllDogs();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _energyLevelsDropdownController.addListener(onSelectionChange);
      _locationDropdownController.addListener(onSelectionChange);
      _comparisonDropdownController.addListener(onSelectionChange);
      _weightTextController.addListener(onSelectionChange);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getAllDogs();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _energyLevelsDropdownController.dispose();
    _locationDropdownController.dispose();
    _comparisonDropdownController.dispose();
    _weightTextController.dispose();
    super.dispose();
  }

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Energy level dropdown menu
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Energy Level: '),
              DropdownMenu<EnergyLevel>(
                initialSelection: EnergyLevel.all,
                controller: _energyLevelsDropdownController,
                dropdownMenuEntries: energyLevelEntries,
              )
            ],
          ),
          // Location dropdown menu
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('City: '),
              DropdownMenu<Location>(
                initialSelection: Location.all,
                controller: _locationDropdownController,
                dropdownMenuEntries: locationEntries,
              )
            ],
          ),
          // Comparison dropdown menu
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Weight: '),
              DropdownMenu(
                width: 100,
                controller: _comparisonDropdownController,
                dropdownMenuEntries: comparisonEntries,
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  controller: _weightTextController,
                  showCursor: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _queriedDogs.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_queriedDogs[index]['f_name']),
                    subtitle: Text(
                        '${_queriedDogs[index]['city']}, ${_queriedDogs[index]['state']}\t\t\t ${_queriedDogs[index]['energy_level']} energy'),
                    trailing: Text('${_queriedDogs[index]['weight']} lbs'),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
