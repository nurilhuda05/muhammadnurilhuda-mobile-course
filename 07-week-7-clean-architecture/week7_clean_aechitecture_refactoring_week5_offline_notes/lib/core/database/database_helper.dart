import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Membuka (atau membuat) database SQLite untuk seluruh aplikasi.
///
/// Ditempatkan di `core/` karena database adalah infrastruktur
/// yang bisa digunakan oleh banyak fitur, bukan hanya notes.
Future<Database> openNotesDb() async {
  final dir = await getDatabasesPath();

  return openDatabase(
    p.join(dir, 'clean_notes.db'),
    version: 2,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          body TEXT NOT NULL DEFAULT '',
          updated_at TEXT NOT NULL,
          dirty INTEGER NOT NULL DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE announcements(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL DEFAULT '',
          created_at TEXT NOT NULL
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
          CREATE TABLE announcements(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL DEFAULT '',
            created_at TEXT NOT NULL
          )
        ''');
      }
    },
  );
}
