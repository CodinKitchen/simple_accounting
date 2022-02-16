import 'package:simple_accouting/database/db_helper.dart';
import 'package:simple_accouting/database/models/account.dart';
import 'package:simple_accouting/database/models/operation.dart';
import 'package:sqflite_common/sql.dart' show ConflictAlgorithm;

class OperationRepository {
  static Future<List<Operation>> all() async {
    final database = await DBHelper.database();
    final result = await database.rawQuery(
        'SELECT o.*, a.name, a.code  FROM ${Operation.table} o INNER JOIN ${Account.table} a ON o.account_id = a.id');
    return result.isNotEmpty
        ? result.map((item) => Operation.fromDatabase(item)).toList()
        : [];
  }

  static void save(Operation operation) async {
    final database = await DBHelper.database();
    database.insert(
      Operation.table,
      operation.toDatabase(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
