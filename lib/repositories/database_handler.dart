import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHandler {
  setDatabase() async{
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_help_now');
    var database = await openDatabase(path, version: 1, onCreate: _onCreateDatabase);
    return database;
  }

  _onCreateDatabase(Database database, int version) async{
    await database.execute(
        'CREATE TABLE forms('
            'phone TEXT PRIMARY KEY,'
            'name TEXT,'
            'productType TEXT,'
            'amount TEXT,'
            'amountType TEXT,'
            'date TEXT,'
            'imageLoc TEXT)'
    );
  }
}