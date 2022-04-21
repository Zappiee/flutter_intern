import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:internship_assessment/model/databasemodel.dart';

class MainPageDesign extends StatelessWidget {
  const MainPageDesign({
    Key? key,
    required this.newstaffdata,
    required this.index,
  }) : super(key: key);

  final DatabaseModel newstaffdata;
  final int index;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.yMd().add_jm().format(newstaffdata.checkin);

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            newstaffdata.staffname,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            newstaffdata.number,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            time,
            style: TextStyle(color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}