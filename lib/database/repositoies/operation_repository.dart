import 'package:intl/intl.dart';
import 'package:simple_accouting/database/db_helper.dart';
import 'package:simple_accouting/database/models/account.dart';
import 'package:simple_accouting/database/models/operation.dart';
import 'package:sqflite_common/sql.dart' show ConflictAlgorithm;

class OperationRepository {
  static Future<List<Operation>> allByDates(
      DateTime? from, DateTime? to) async {
    final database = await DBHelper.database();
    String whereClause = '';
    List whereParams = [];
    if (from != null) {
      whereClause = ' WHERE o.date >= ?';
      whereParams = [DateFormat('yyyy-MM-dd').format(from)];
      if (to != null) {
        whereClause += ' AND o.date <= ?';
        whereParams.add(DateFormat('yyyy-MM-dd').format(to));
      }
    } else {
      if (to != null) {
        whereClause = 'WHERE o.date <= ?';
        whereParams = [DateFormat('yyyy-MM-dd').format(to)];
      }
    }

    final result = await database.rawQuery(
        'SELECT o.*, a.name, a.code FROM ${Operation.table} o INNER JOIN ${Account.table} a ON o.account_id = a.id' +
            whereClause,
        whereParams);
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

  static void remove(Operation operation) async {
    final database = await DBHelper.database();
    database.delete(
      Operation.table,
      where: 'id = ?',
      whereArgs: [operation.id],
    );
  }
}
