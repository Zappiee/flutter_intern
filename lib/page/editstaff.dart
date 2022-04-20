import 'package:flutter/material.dart';
import 'package:internship_assessment/db/databaseconnection.dart';
import 'package:internship_assessment/model/databasemodel.dart';
import 'package:internship_assessment/page/staffpagewidget.dart';

class EditStaff extends StatefulWidget {
  
  final DatabaseModel? staffdata;

  const EditStaff({
    Key? key,
    this.staffdata,
  }) : super(key: key);
  @override
  _EditStaffState createState() => _EditStaffState();
}

class _EditStaffState extends State<EditStaff> {
  final _formKey = GlobalKey<FormState>();
  late int? id;
  late String staffname;
  late String number;
  late DateTime checkin;

  @override
  void initState() {
    super.initState();

    number = widget.staffdata?.number ?? '';
    staffname = widget.staffdata?.staffname?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: StaffPageWidget(
            staffname: staffname,
            number: number,
            onChangedNumber: (number) => setState(() => this.number = number),
            onChangedName: (title) => setState(() => staffname = staffname),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = staffname.isNotEmpty && number.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: const Text('Check in and update'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.staffdata != null;

      if (isUpdating) {
        await updatestaff();
      } else {
        await updatecheckin();
      }

      Navigator.of(context).pop();
    }
  }

  Future updatestaff() async {
    final staffdata = widget.staffdata!.copy(
      staffname: staffname,
      number: number,
    );

    await DatabaseConnection.instance.update(staffdata);
  }

  Future updatecheckin() async {
    final staffdata = DatabaseModel(
      staffname: staffname,
      number: number,
      checkin: DateTime.now(),
    );

    await DatabaseConnection.instance.create(staffdata);
  }
}
