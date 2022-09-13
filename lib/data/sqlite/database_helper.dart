import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  static const _databaseName = 'MyRecipes.db';
  static const _databaseVersion = 1;

  static const recipeTable = 'Recipe';
  static const ingredientTable = 'Ingredient';
  static const recipeId = 'recipeId';
  static const ingredientId = 'ingredientId';

  static late BriteDatabase _streamDatabase;

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static var lock = Lock();

  // only have a single app-wide reference to the database
  static Database? _database;

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $recipeTable (
    $recipeId INTEGER PRIMARY KEY,
    label TEXT,
    calories REAL,
    totalWeight REAL,
    totalTime REAL
    )
    ''');

    await db.execute('''CREATE TABLE $ingredientTable (
    $ingredientId INTEGER PRIMARY KEY,
    $recipeId INTEGER,
    name TEXT,
    weight REAL
    )
    ''');
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    // TODO: Remember to turn off debugging before deploying app to store(S)
    Sqflite.setDebugModeOn(true);

    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    //Use this object to prevent concurrent access to the data
    await lock.synchronized(() async {
      // lazily instantiate the db the first time it is accessed
      if (_database == null) {
        _database = await _initDatabase();
        _streamDatabase = BriteDatabase(_database!);
      }
    });
    return _database!;
  }

  Future<Database> get streamDatabase async {
    await database;
    return _streamDatabase;
  }

  // TODO: Add parseRecipe here
}
