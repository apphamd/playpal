import 'package:flutter/material.dart';
import 'package:playpal/service/report_service.dart';

class ReportMenuButton extends StatefulWidget {
  const ReportMenuButton({
    super.key,
    required this.reportingUserId,
    required this.reportedUserId,
  });
  final String reportingUserId;
  final String reportedUserId;

  @override
  State<ReportMenuButton> createState() => _ReportMenuButtonState();
}

class _ReportMenuButtonState extends State<ReportMenuButton> {
  final TextEditingController reasonController = TextEditingController();
  bool somethingElse = false;

  onSelectionChange() {
    // something else logic
    print(reasonController.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      somethingElse = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reasonController.addListener(onSelectionChange);
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<ReportChoices>> reasonEntries =
        <DropdownMenuEntry<ReportChoices>>[];
    for (final ReportChoices reason in ReportChoices.values) {
      reasonEntries.add(
        DropdownMenuEntry<ReportChoices>(value: reason, label: reason.text),
      );
    }

    return MenuItemButton(
      child: const Text('Report'),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Center(child: Text('Report Profile')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please select a reason'),
              const SizedBox(height: 10),
              DropdownMenu(
                width: 250,
                menuHeight: 330.0,
                controller: reasonController,
                dropdownMenuEntries: reasonEntries,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ReportService.insertReport(widget.reportingUserId,
                    widget.reportedUserId, reasonController.text);
                Navigator.pop(context, 'OK');
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ReportChoices {
  spam('Spam'),
  nudity('Nudity or sexual content'),
  fraud('Fraud'),
  bullying('Bullying or harassment'),
  hate('Hate speech or symbols'),
  violence('Violent content'),
  illegal('Illegal activity'),
  hacked('Account may have been hacked');
  // somethingElse('Something else');

  const ReportChoices(this.text);
  final String text;
}
