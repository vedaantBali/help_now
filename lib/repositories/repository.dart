import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database_handler.dart';

class Repository {
  DatabaseHandler _databaseHandler;

  Repository() {
    _databaseHandler = DatabaseHandler();
  }

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _databaseHandler.setDatabase();

    return _database;
  }

  insertData(table, data) async{
    var connection = await database;
    return await connection.insert('forms', data);
  }

  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  deleteData(table, phone) async{
    var connection = await database;
    return await connection.rawDelete('DELETE FROM $table WHERE phone = $phone');
  }

  executeExportCsv(String table, fromDate, toDate) async{
    var connection = await database;
    // var result = await connection
    //     .rawQuery('SELECT * FROM $table WHERE date BETWEEN $toDate and $fromDate');
    var result =  await connection
        .rawQuery(
        'SELECT phone, name, productType, amount, amountType, date FROM $table'
    );
    var csv = mapListToCsv(result);


    File file = File(await getFilePath());
    await file.writeAsString(csv);
    // print(file.path);
    // print(csv);
  }

  String mapListToCsv(List<Map<String, dynamic>> mapList,
      {ListToCsvConverter converter}) {
    if (mapList == null) {
      return null;
    }
    converter ??= const ListToCsvConverter();
    var data = <List>[];
    var keys = <String>[];
    var keyIndexMap = <String, int>{};

    // Add the key and fix previous records
    int _addKey(String key) {
      var index = keys.length;
      keyIndexMap[key] = index;
      keys.add(key);
      for (var dataRow in data) {
        dataRow.add(null);
      }
      return index;
    }

    for (var map in mapList) {
      // This list might grow if a new key is found
      var dataRow = List<dynamic>.filled(keyIndexMap.length, null);
      // Fix missing key
      map.forEach((key, value) {
        var keyIndex = keyIndexMap[key];
        if (keyIndex == null) {
          // New key is found
          // Add it and fix previous data
          keyIndex = _addKey(key);
          // grow our list
          dataRow = List.from(dataRow, growable: true)..add(value);
        } else {
          dataRow[keyIndex] = value;
        }
      });
      data.add(dataRow);
    }
    return converter.convert(<List>[keys, ...data]);
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getExternalStorageDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/csv-${DateTime.now()}.csv';

    return filePath;
  }


}