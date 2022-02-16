import 'package:simple_accouting/database/db_helper.dart';
import 'package:simple_accouting/database/models/profile.dart';
import 'package:sqflite_common/sql.dart' show ConflictAlgorithm;

class ProfileRepository {
  static Future<Profile> loadProfile() async {
    final database = await DBHelper.database();
    final result =
        await database.query(Profile.table, where: 'id = ?', whereArgs: [1]);

    return result.isNotEmpty ? Profile.fromDatabase(result.first) : Profile();
  }

  static void save(Profile profile) async {
    final database = await DBHelper.database();
    database.insert(
      Profile.table,
      profile.toDatabase(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
