import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)',
        );
      },
    );
  }

  Future<bool> registerUser(String username, String password) async {
    final db = await database;

    // Cek apakah username sudah ada
    final List<Map<String, dynamic>> existingUser = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (existingUser.isNotEmpty) return false;

    await db.insert('users', {'username': username, 'password': password});
    return true;
  }

  Future<bool> loginUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return users.isNotEmpty;
  }
}
