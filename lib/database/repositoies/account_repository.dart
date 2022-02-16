import 'package:simple_accouting/database/db_helper.dart';
import 'package:simple_accouting/database/models/account.dart';
import 'package:sqflite_common/sql.dart' show ConflictAlgorithm;

class AccountRepository {
  static Future<List<Account>> all() async {
    final database = await DBHelper.database();
    final result = await database.query(Account.table, orderBy: 'name ASC');
    return result.isNotEmpty
        ? result.map((item) => Account.fromDatabase(item)).toList()
        : [];
  }

  static void save(Account account) async {
    final database = await DBHelper.database();
    database.insert(
      Account.table,
      account.toDatabase(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static void remove(Account account) async {
    final database = await DBHelper.database();
    database.delete(
      Account.table,
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }
}
