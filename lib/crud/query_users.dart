import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QueryUsers extends StatefulWidget {
  const QueryUsers({super.key});

  @override
  State<QueryUsers> createState() => _QueryUsersState();
}

class _QueryUsersState extends State<QueryUsers> {
  final db = FirebaseFirestore.instance;

  List _allUsers = [];
  List _queriedUsers = [];

  final TextEditingController _dropdownController = TextEditingController();

  getAllUsers() async {
    var data = await db.collection("users").get();
    setState(() {
      _allUsers = data.docs;
    });
    filterResults();
  }

  onSelectionChange() {
    print(_dropdownController.text);
    filterResults();
  }

  filterResults() {
    var showResults = [];
    for (var clientSnapshot in _allUsers) {
      var city = clientSnapshot['city'].toString().toLowerCase();
      if (city.contains(_dropdownController.text.toLowerCase())) {
        showResults.add(clientSnapshot);
      }
    }
    setState(() {
      _queriedUsers = showResults;
    });
  }

  @override
  void initState() {
    getAllUsers();
    _dropdownController.addListener(onSelectionChange);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getAllUsers();
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
    final List<DropdownMenuEntry<String>> queriedCities = [
      const DropdownMenuEntry(value: 'Ocean Springs', label: 'Ocean Springs'),
      const DropdownMenuEntry(value: 'Oxford', label: 'Oxford'),
      const DropdownMenuEntry(value: 'Jackson', label: 'Jackson'),
      const DropdownMenuEntry(value: 'Dallas', label: 'Dallas'),
    ];

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('City: '),
                DropdownMenu(
                  controller: _dropdownController,
                  dropdownMenuEntries: queriedCities,
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _queriedUsers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_queriedUsers[index]['f_name']),
                    subtitle: Text(
                        "${_queriedUsers[index]['city']}, ${_queriedUsers[index]['state']}"),
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
