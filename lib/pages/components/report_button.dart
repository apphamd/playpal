import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  ReportButton({
    super.key,
    required this.onTap,
    required this.size,
  });
  final double size;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.report_problem_rounded,
        color: Colors.amber,
        size: size,
      ),
    );
  }
}
