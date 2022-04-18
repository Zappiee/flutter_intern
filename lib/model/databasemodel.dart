// creating the table
const String staffdatatable = 'staffdatatable';

// create value list so that data can be retrieved
class StaffDataTable{
  static final List<String> values = [
    id, staffname, number, checkin
  ];

  // pass all the field inside the list
  static const String id = '_id';
  static const String staffname = 'staffname';
  static const String number = 'phone_number';
  static const String checkin = 'checkin_time';
}

// to define all the fieldname 
class StaffDataFields {
  static const String id = '_id';
  static const String staffname = 'staffname';
  static const String number = 'phone_number';
  static const String checkin = 'checkin_time';

}

// to define the data data type of each data in every field before creating staffdata.db
class DatabaseModel {
  final int? id;
  final String staffname;
  final String number;
  final DateTime checkin;

  const DatabaseModel({
    this.id,
    required this.staffname,
    required this.number,
    required this.checkin,
  });

// to create a copy of object and pass all the values inside
  DatabaseModel copy({
    int? id,
    String? staffname,
    String? number,
    DateTime? checkin,

  })=>
      DatabaseModel(
        id: id ?? this.id,
        staffname: staffname ?? this.staffname,
        number: number ?? this.number,
        checkin: checkin ?? this.checkin,
      );

  // after retriving the data convert it back to the original data type
  static DatabaseModel fromJson(Map<String, Object?> json)=> DatabaseModel(
    id: json[StaffDataFields.id] as int?,
    staffname: json[StaffDataFields.staffname] as String,
    number: json[StaffDataFields.number] as String,
    checkin: DateTime.parse(json[StaffDataFields.checkin] as String),
  );

  // create a map for data containing arrays
  Map<String, Object?> toJson() =>{
    StaffDataFields.id: id,
    StaffDataFields.staffname: staffname,
    StaffDataFields.number: number,
    StaffDataFields.checkin: checkin.toIso8601String(),
  };
}