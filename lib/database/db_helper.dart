import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'migrations/migration_06022022.dart';

class DBHelper {
  static Future<Database> database() async {
    // Init ffi loader if needed.
    SqfliteFfiInit;

    var databaseFactory = databaseFactoryFfi;
    var databasePath = await getApplicationDocumentsDirectory();
    return await databaseFactory.openDatabase(
        join(databasePath.path, "simple_accounting.db"),
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (Database database, int version) async {
            Migration06022022.up(database);
          },
          onOpen: (Database database) =>
              database.execute("PRAGMA foreign_keys = ON"),
        ));
  }
}
