import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:playpal/pages/admin/report_page.dart';

class ReportsFeed extends StatefulWidget {
  const ReportsFeed({super.key});

  @override
  State<ReportsFeed> createState() => _ReportsFeedState();
}

class _ReportsFeedState extends State<ReportsFeed> {
  CollectionReference reportsRef =
      FirebaseFirestore.instance.collection('reports');
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: StreamBuilder(
        stream: reportsRef.snapshots(),
        builder: (context, reportSnapshot) {
          if (!reportSnapshot.hasData) {
            return const Text('There are no reports!');
          }

          // add all the reports to a list
          List reports = [];
          var reportData = reportSnapshot.data!;
          for (var doc in reportData.docs) {
            reports.add(doc.data());
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              // this second stream builder is important so we can
              // match the given user ids to the respective user.
              return StreamBuilder(
                stream: usersRef.snapshots(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const Text('There are no users!');
                  }
                  // Strings for use
                  String reportingUserId = reports[index]['reporting-user-id'];
                  String reportedUserId = reports[index]['reported-user-id'];
                  String reportingUserName = '';
                  String reportedUserName = '';

                  var userData = userSnapshot.data!;
                  for (var doc in userData.docs) {
                    Map data = doc.data() as Map;
                    if (doc.id == reportingUserId) {
                      reportingUserName = data['f_name'] + ' ' + data['l_name'];
                    } else if (doc.id == reportedUserId) {
                      reportedUserName = data['f_name'] + ' ' + data['l_name'];
                    }
                  }

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('${reports[index]['reason']}'),
                        ),
                        subtitle: Text(
                            'Offender: $reportedUserName \nid: ${reports[index]['reported-user-id']} \nReporter: $reportingUserName \nid: ${reports[index]['reporting-user-id']}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReportPage(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
