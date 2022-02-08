import 'package:sqflite_common/sqlite_api.dart';

class Migration06022022 {
  static Future<void> up(Database database) async {
    await database.execute("""
        CREATE TABLE account_categories (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          code TEXT NOT NULL
        )
    """);

    await database.execute("""
        CREATE TABLE accounts (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          code TEXT NOT NULL,
          account_category_id INTEGER NOT NULL,
          FOREIGN KEY(account_category_id) REFERENCES account_categories(id)
        )
    """);

    await database.execute("""
        CREATE TABLE operations (
          id INTEGER PRIMARY KEY,
          amount DOUBLE NOT NULL,
          date DATE NOT NULL DEFAULT CURRENT_DATE,
          account_id INTEGER NOT NULL,
          FOREIGN KEY(account_id) REFERENCES accounts(id)
        )
    """);
  }
}
