import 'dart:async';

import 'package:internship_assessment/model/databasemodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseConnection{
  static final DatabaseConnection instance = DatabaseConnection._init();

  // Database? is used instead of Database because u cannot store null values in database
  // by using Database? it allows to point to a Database object or null
  static Database? _database;

  DatabaseConnection._init();

// opens the conenction to the database
  Future<Database?> get database async {
    // if the database exist then return the value
    if (_database != null){
      return _database;
    }

    // if _database is null we initialise it in staffdata.db
    else{
      _database = await _initDB('staffdata.db');
      return _database;
    }
  }

    // initialise the database by getting filepath
    Future<Database> _initDB(String filePath) async{
      // storing the database in the android file storage system
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      // open the database
      return await openDatabase(path, version: 1, onCreate: _createDB);
    }
    
    // will execute the database command and create the table if the database file dont exist
    Future _createDB(Database db, int version) async{

      // specify the type of data that will be created in the SQL database
      const textType  = 'TEXT NOT NULL';
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
      
      await db.execute('''
        CREATE TABLE $staffdatatable(
          ${StaffDataFields.id} $idType,
          ${StaffDataFields.staffname} $textType,
          ${StaffDataFields.number} $textType,
          ${StaffDataFields.checkin} $textType
        )
      ''');
    }

    Future<DatabaseModel> create(DatabaseModel staffdata) async{
      // get reference to database
      final db = await instance.database;

      //insert to data into database table
      final id = await db!.insert(staffdatatable, staffdata.toJson());
      return staffdata.copy(id:id);

    }


    // to read the database
    Future<DatabaseModel> readData(int id) async{
      // defining database
      final db = await instance.database;

      final maps = await db!.query(
        staffdatatable,
        // define all the column u want to retrieve from the table
        columns: StaffDataTable.values,

        // define which object u want to read
        where: '${StaffDataTable.id} = ?',
        whereArgs: [id],
      );

      // convert first item of the list and convert it back to to object
      if (maps.isNotEmpty){
        return DatabaseModel.fromJson(maps.first);
      }
      else{
        throw Exception('ID $id is not found');
      }
    }

    // to read multiple data
    Future<List<DatabaseModel>> readAllData() async{
      // get all the database instances
      final db = await instance.database;

      // to create the data where it will display the most recent
      const ascendingorder = '${StaffDataFields.checkin} ASC';  
      final result = await db!.query(staffdatatable, orderBy: ascendingorder);

      // convert json object back to database model object
      return result.map((json) => DatabaseModel.fromJson(json)).toList();
    }


    // to update the database when changes are made
    Future<int> update(DatabaseModel staffdata) async{
      final db = await instance.database;
    
      return db!.update(
        staffdatatable,
        staffdata.toJson(),

        // define which database model u want to update
        where: '${StaffDataFields.id} = ?',
        whereArgs:  [staffdata.id],
      );
    }

    // to delete data
    Future<int> delete(int id) async{
    final db = await instance.database;

    return await db!.delete(
      staffdatatable,

      // define which database model u want to delete
        where: '${StaffDataFields.id} = ?',
        whereArgs:  [id],
      );
    }

    Future close()async{
      final db= await instance.database;

      db!.close();
    }
}
