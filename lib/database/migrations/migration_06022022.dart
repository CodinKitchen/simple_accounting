import 'package:sqflite_common/sqlite_api.dart';

class Migration06022022 {
  static Future<void> up(Database database) async {
    await database.execute("""
        PRAGMA foreign_keys = ON;
    """);

    await database.execute("""
        CREATE TABLE profiles (
          id INTEGER PRIMARY KEY,
          first_name TEXT,
          last_name TEXT,
          bank_iban TEXT,
          bank_name TEXT,
          initial_balance REAL
        )
    """);

    await database.execute("""
        CREATE TABLE accounts (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          code TEXT NOT NULL,
          profile_id INTEGER NOT NULL,
          FOREIGN KEY(profile_id) REFERENCES profiles(id)
        )
    """);

    await database.execute("""
        CREATE TABLE operations (
          id INTEGER PRIMARY KEY,
          amount DOUBLE NOT NULL,
          date DATE NOT NULL DEFAULT CURRENT_DATE,
          account_id INTEGER NOT NULL,
          profile_id INTEGER NOT NULL,
          FOREIGN KEY(account_id) REFERENCES accounts(id),
          FOREIGN KEY(profile_id) REFERENCES profiles(id)
        )
    """);
  }
}
