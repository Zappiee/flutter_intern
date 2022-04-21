import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:internship_assessment/db/databaseconnection.dart';
import 'package:internship_assessment/model/databasemodel.dart';
import 'package:internship_assessment/page/editstaff.dart';
import 'package:internship_assessment/page/staff_detail_page.dart';
import 'package:internship_assessment/page/mainpagedesign.dart';

class DisplayMain extends StatefulWidget {
  @override
  _DisplayMainState createState() => _DisplayMainState();
}

class _DisplayMainState extends State<DisplayMain> {
  late List<DatabaseModel> staffdata;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshPage();
  }

  @override
  void dispose() {
    DatabaseConnection.instance.close();

    super.dispose();
  }

  Future refreshPage() async {
    setState(() => isLoading = true);

    staffdata = await DatabaseConnection.instance.readAllData();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Staff Data',
            style: TextStyle(fontSize: 24),
          ),
          actions: const [Icon(Icons.search), SizedBox(width: 12)],
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : staffdata.isEmpty
                  ? const Text(
                      'No data of staff found',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : displaystaff(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EditStaff()),
            );

            refreshPage();
          },
        ),
      );

  Widget displaystaff() => StaggeredGridView.countBuilder(
        itemCount: staffdata.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 10,
        itemBuilder: (context, index) {
          final newstaffdata = staffdata[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StaffDetailPage(staffid: newstaffdata.id!),
              ));

              refreshPage();
            },
            child: MainPageDesign(newstaffdata: newstaffdata, index: index),
          );
        },
      );
}
