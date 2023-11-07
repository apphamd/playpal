import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static String generateReportId(
    String reportingUserId,
    String reportedUserId,
  ) {
    List ids = [];
    ids.add(reportingUserId);
    ids.add(reportedUserId);
    ids.sort();
    return ids[0] + '_' + ids[1];
  }

  static void insertReport(
    String reportingUserId,
    String reportedUserId,
    String reason,
  ) async {
    String id = generateReportId(reportingUserId, reportedUserId);
    print('$reportingUserId $reportedUserId $id $reason');
    await db.collection('reports').doc(id).set({
      'reporting-user-id': reportingUserId,
      'reported-user-id': reportedUserId,
      'reason': reason,
    });
  }
}
