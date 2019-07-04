import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache{
  Database db;

//because the new instance of NewsDbProvider is defined outside the init
  NewsDbProvider(){
    init();
  }

  //this is an empty method because implements Source has 
  // this method return as a requirement
  // TODO - could be used to store and fetch ids
  Future<List<int>>fetchTopIds(){
    return null;
  }

//nothing returned so therefore void
  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items2.db");

    /*in sqlite there are no boolean types or lists
    these are replaced by integers ( 0 == false, 1 == true) and 
    BLOB respectively*/

    //table uses 3 """

    // deletes the db for a recreate if the structure is built incorrectly
     await deleteDatabase(path);

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version){
        newDb.execute("""
          CREATE TABLE Items 
          (
            id INTEGER PRIMARY KEY,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            parent INTEGER,
            kids BLOB,
            dead INTEGER, 
            deleted INTEGER, 
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
        """);
      },
    );
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      columns: null, // all columns under Items table
      where: "id = ?", //id unknown, drawn from first element in whereArgs list
      whereArgs: [id], //this is done to prevent sql injection attacks
    );

    if (maps.length > 0){
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

// no async because we are not waiting for the insert to do anything else
//hover over db.insert indicates that it returns Future<int>
  Future<int> addItem(ItemModel item) {
    return db.insert("Items", 
    item.toMapForDb(),
    //easy way to circumvent conflict error when reading and writing
    //conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

//delete table called Items and returns the future
  Future<int> clear(){
    return db.delete("Items");
  }
}


//because sqlite doesnt like opening the same db twice we create a new instance of it and ref that
// in the repository
final newsDbProvider = NewsDbProvider();