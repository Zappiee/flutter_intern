import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:internship_assessment/db/databaseconnection.dart';
import 'package:internship_assessment/model/databasemodel.dart';
import 'package:internship_assessment/page/editstaff.dart';
import 'package:url_launcher/url_launcher.dart';

class StaffDetailPage extends StatefulWidget {
  final int staffid;

  const StaffDetailPage({
    Key? key,
    required this.staffid,
  }) : super(key: key);

  @override
  _StaffDetailPage createState() => _StaffDetailPage();
}

class _StaffDetailPage extends State<StaffDetailPage> {
  late DatabaseModel staffdata;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshpage();
  }

  Future refreshpage() async {
    setState(() => isLoading = true);
    
    staffdata = await DatabaseConnection.instance.readData(widget.staffid);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [shareButton(), editButton(), deleteButton()]
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      staffdata.staffname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(staffdata.checkin),
                      style: const TextStyle(color: Colors.white38),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      staffdata.number,
                      style: const TextStyle(color: Colors.white70, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget shareButton() => IconButton(
      icon: const Icon(Icons.share),
      onPressed: () async{
        final staffname = staffdata.staffname;
        final contactnumber = staffdata.number;
        final url = 'mailto:?subject=$staffname&body=$contactnumber';

        if(await canLaunch(url)){
          await launch(url);
        }
      }
  );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EditStaff(staffdata : staffdata),
        ));

        refreshpage();
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await DatabaseConnection.instance.delete(widget.staffid);

          Navigator.of(context).pop();
        },
      );
}
