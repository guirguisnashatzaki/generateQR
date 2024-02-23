import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'clientObject.dart';

class DBHelper{

  static Database? _db;

  Future<Database?> get db async{
    if(_db!=null){
      return _db;

    }
    _db=await initDatabase();

    return _db;


  }

  initDatabase() async{
    io.Directory documentDirectory=await getApplicationDocumentsDirectory();
    String path=join(documentDirectory.path,'HotelSystem.db');
    var db=await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{
    await db.execute(
        "CREATE TABLE hotel (id INTEGER PRIMARY KEY AUTOINCREMENT,"
            " name TEXT NOT NULL,"
            " email TEXT NOT NULL,"
            " phone TEXT NOT NULL,"
            " address TEXT NOT NULL,"
            " carNumber TEXT NOT NULL,"
            " bookingDate TEXT NOT NULL,"
            " bookingTime TEXT NOT NULL,"
            " service TEXT NOT NULL,"
            " price DOUBLE NOT NULL)",
    );
  }


  Future<MyClient> insert(MyClient dbModel) async{

    var dbClient= await db;
    await dbClient!.insert('hotel', dbModel.toJson());

    return dbModel;
  }

  
  Future<List<MyClient>> getList() async{

    var dbClient= await db;
    final List<Map<String,Object?>> queryResult=await dbClient!.query('hotel');

    return queryResult.map((e) => MyClient.fromJson(e)).toList();
  }

  Future<int> deleteUser(int id) async{

    var dbClient= await db;

    return await dbClient!.delete(
      'hotel',
      where: 'id=?',
      whereArgs: [id]
    ) ;
  }

  Future<int > updateUser(MyClient dbModel) async{

    var dbClient= await db;

    return await dbClient!.update(
      'hotel',
      dbModel.toJson(),
      where: 'id=?',
      whereArgs: [dbModel.id]
    ) ;
  }
}