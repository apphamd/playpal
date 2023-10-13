import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QueryDogs extends StatefulWidget {
  const QueryDogs({super.key});

  @override
  State<QueryDogs> createState() => _QueryDogsState();
}

class _QueryDogsState extends State<QueryDogs> {
  final db = FirebaseFirestore.instance;
  String _field = '';

  List _allDogs = [];
  List _queriedDogs = [];

  final TextEditingController _dropdownController = TextEditingController();

  getAllDogs() async {
    List allDogs = [];
    var userData = await db.collection('users').get();
    for (var user in userData.docs) {
      var singleUserDogData =
          await db.collection('users').doc(user.id).collection('dogs').get();
      for (var dog in singleUserDogData.docs) {
        allDogs.add(dog.data());
        // print(dog.reference.parent.id);
      }
    }
    setState(() {
      _allDogs = allDogs;
    });
    filterResults(_field);
  }

  onSelectionChange() {
    print(_dropdownController.text);
    filterResults(_field);
  }

  void filterResults(field) {
    var showResults = [];

    if (_dropdownController.text.toLowerCase() == 'all') {
      showResults = _allDogs;
    } else {
      for (var clientSnapshot in _allDogs) {
        var energyLevel = clientSnapshot[field].toString().toLowerCase();
        if (energyLevel.contains(_dropdownController.text.toLowerCase())) {
          showResults.add(clientSnapshot);
        }
      }
    }
    setState(() {
      _queriedDogs = showResults;
    });
  }

  @override
  void initState() {
    getAllDogs();
    _dropdownController.addListener(onSelectionChange);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getAllDogs();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dropdownController.removeListener(onSelectionChange());
    _dropdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> energyLevels = [
      const DropdownMenuEntry(value: 'High', label: 'High'),
      const DropdownMenuEntry(value: 'Medium', label: 'Medium'),
      const DropdownMenuEntry(value: 'Low', label: 'Low'),
      const DropdownMenuEntry(value: 'All', label: 'All'),
    ];

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Energy Level: '),
                DropdownMenu(
                  controller: _dropdownController,
                  dropdownMenuEntries: energyLevels,
                  onSelected: (value) {
                    setState(() {
                      _field = 'energy_level';
                    });
                  },
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _queriedDogs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_queriedDogs[index]['f_name']),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
